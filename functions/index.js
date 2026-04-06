const admin = require('firebase-admin');
const {logger} = require('firebase-functions');
const {onSchedule} = require('firebase-functions/v2/scheduler');

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

exports.sendAiInsightAlerts = onSchedule(
  {
    schedule: 'every day 20:45',
    timeZone: 'Asia/Kolkata',
    region: 'asia-south1',
    memory: '256MiB',
  },
  async () => {
    const usersSnapshot = await db.collection('users').get();
    let sentCount = 0;

    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data() || {};
      const settings = userData.notificationSettings || {};
      const token = typeof userData.fcmToken === 'string' ? userData.fcmToken : '';
      const aiEnabled = userData.aiEnabled !== false;
      const pushEnabled = settings.pushEnabled !== false;
      const aiAlertsEnabled = settings.aiAlertsEnabled !== false;

      if (!token || !aiEnabled || !pushEnabled || !aiAlertsEnabled) {
        continue;
      }

      const transactionsSnapshot = await userDoc.ref
        .collection('transactions')
        .orderBy('date', 'desc')
        .limit(180)
        .get();

      const transactions = transactionsSnapshot.docs
        .map((doc) => normalizeTransaction(doc.data()))
        .filter(Boolean);

      if (transactions.length < 4) {
        continue;
      }

      const budgets = normalizeBudgets(userData.budgets || {});
      const monthlyIncome = toAmount(userData.monthlyIncome);
      const signal = buildAiSignal({transactions, budgets, monthlyIncome});

      if (!signal) {
        continue;
      }

      const notificationKey = `${todayKey()}_${signal.key}`;
      const previousKey = userData.notificationMeta?.lastAiPushKey;
      if (notificationKey === previousKey) {
        continue;
      }

      try {
        await messaging.send({
          token,
          notification: {
            title: signal.title,
            body: signal.body,
          },
          data: {
            type: 'ai_insight',
            category: signal.categoryKey,
            route: signal.route,
          },
          android: {
            priority: 'high',
            notification: {
              channelId: 'finova_ai_alerts',
            },
          },
          apns: {
            payload: {
              aps: {
                sound: 'default',
              },
            },
          },
        });

        await userDoc.ref.set(
          {
            notificationMeta: {
              lastAiPushKey: notificationKey,
              lastAiPushAt: admin.firestore.FieldValue.serverTimestamp(),
            },
          },
          {merge: true},
        );

        sentCount += 1;
      } catch (error) {
        logger.error(`Failed to send AI alert to ${userDoc.id}`, error);
      }
    }

    logger.info(`AI alerts sent: ${sentCount}`);
  },
);

function normalizeTransaction(raw) {
  const dateValue = raw?.date;
  const date = dateValue?.toDate ? dateValue.toDate() : null;
  if (!(date instanceof Date) || Number.isNaN(date.getTime())) {
    return null;
  }

  return {
    title: String(raw?.title || '').trim(),
    categoryKey: normalizeCategory(raw?.category),
    amount: toAmount(raw?.amount),
    date,
  };
}

function normalizeBudgets(raw) {
  const budgets = {};
  for (const [key, value] of Object.entries(raw || {})) {
    budgets[normalizeCategory(key)] = toAmount(value);
  }
  return budgets;
}

function buildAiSignal({transactions, budgets, monthlyIncome}) {
  const now = new Date();
  const currentStart = new Date(now);
  currentStart.setDate(currentStart.getDate() - 30);
  const previousStart = new Date(now);
  previousStart.setDate(previousStart.getDate() - 60);

  const last30 = transactions.filter((tx) => tx.date >= currentStart);
  const previous30 = transactions.filter(
    (tx) => tx.date < currentStart && tx.date >= previousStart,
  );

  if (last30.length < 2) {
    return null;
  }

  const currentTotals = sumByCategory(last30);
  const previousTotals = sumByCategory(previous30);
  const allTotals = sumByCategory(transactions);
  const totalCurrent = sumAmounts(last30);
  const totalPrevious = sumAmounts(previous30);
  const monthsCovered = historyMonths(transactions, now);
  const predictedNext = predictNextMonthSpend({
    current30Total: totalCurrent,
    previous30Total: totalPrevious,
    historicalAverage: sumAmounts(transactions) / monthsCovered,
    monthlyIncome,
  });

  const categoryKeys = new Set([
    ...Object.keys(currentTotals),
    ...Object.keys(previousTotals),
    ...Object.keys(allTotals),
    ...Object.keys(budgets),
  ]);
  const candidates = [];

  for (const categoryKey of categoryKeys) {
    const currentAmount = currentTotals[categoryKey] || 0;
    const previousAmount = previousTotals[categoryKey] || 0;
    const categoryBudget = budgets[categoryKey] || 0;
    const trendDelta = currentAmount - previousAmount;
    const trendPercent =
      previousAmount > 0 ? (trendDelta / previousAmount) * 100 : currentAmount > 0 ? 100 : 0;
    const predictedCategory = predictCategoryAmount({
      categoryKey,
      currentTotals,
      previousTotals,
      allTotals,
      predictedNext,
      monthsCovered,
    });

    if (trendDelta >= 400 && trendPercent >= 20) {
      candidates.push({
        score: trendDelta + trendPercent * 8,
        key: `trend_${categoryKey}`,
        categoryKey,
        route: 'ai_insights',
        title: 'AI spending alert',
        body: `${titleCase(categoryKey)} spending is up ${Math.abs(trendPercent).toFixed(0)}%. You spent ${formatCurrency(currentAmount)} in the last 30 days.`,
      });
    }

    if (categoryBudget > 0 && predictedCategory > categoryBudget * 1.08) {
      candidates.push({
        score: (predictedCategory - categoryBudget) + predictedCategory * 0.2,
        key: `budget_risk_${categoryKey}`,
        categoryKey,
        route: 'ai_prediction',
        title: 'AI budget risk detected',
        body: `${titleCase(categoryKey)} may reach ${formatCurrency(predictedCategory)} next month, above your ${formatCurrency(categoryBudget)} budget.`,
      });
    }
  }

  if (monthlyIncome > 0 && predictedNext > monthlyIncome * 1.03) {
    candidates.push({
      score: predictedNext - monthlyIncome + predictedNext * 0.15,
      key: 'income_risk',
      categoryKey: 'overall',
      route: 'ai_prediction',
      title: 'AI forecast warning',
      body: `Your next 30 days may reach ${formatCurrency(predictedNext)}, above your recorded income of ${formatCurrency(monthlyIncome)}.`,
    });
  }

  if (!candidates.length) {
    return null;
  }

  candidates.sort((a, b) => b.score - a.score);
  const topSignal = candidates[0];
  delete topSignal.score;
  return topSignal;
}

function predictNextMonthSpend({
  current30Total,
  previous30Total,
  historicalAverage,
  monthlyIncome,
}) {
  if (current30Total <= 0 && historicalAverage <= 0) {
    return 0;
  }

  const trendProjection =
    previous30Total > 0
      ? current30Total + (((current30Total - previous30Total) / previous30Total) * current30Total * 0.35)
      : current30Total > 0
        ? current30Total * 1.06
        : historicalAverage;

  let prediction =
    current30Total * 0.55 +
    Math.max(0, trendProjection) * 0.25 +
    historicalAverage * 0.2;

  const baseline = Math.max(current30Total, historicalAverage);
  const floor = Math.max(current30Total * 0.78, historicalAverage * 0.7);
  const ceiling = monthlyIncome > 0 ? monthlyIncome * 1.15 : baseline * 1.45;

  prediction = Math.min(Math.max(prediction, floor), ceiling);
  return prediction;
}

function predictCategoryAmount({
  categoryKey,
  currentTotals,
  previousTotals,
  allTotals,
  predictedNext,
  monthsCovered,
}) {
  const recent = currentTotals[categoryKey] || 0;
  const previous = previousTotals[categoryKey] || 0;
  const historyAverage = (allTotals[categoryKey] || 0) / Math.max(monthsCovered, 1);

  let trendProjection;
  if (recent > 0 && previous > 0) {
    trendProjection = recent + (recent - previous) * 0.35;
  } else if (recent > 0) {
    trendProjection = recent * 1.05;
  } else if (previous > 0) {
    trendProjection = previous * 0.82;
  } else {
    trendProjection = historyAverage;
  }

  const rawPrediction = Math.max(
    0,
    recent * 0.55 + Math.max(0, trendProjection) * 0.25 + historyAverage * 0.2,
  );

  const rawTotals = {};
  let rawGrandTotal = 0;
  for (const key of new Set([
    ...Object.keys(currentTotals),
    ...Object.keys(previousTotals),
    ...Object.keys(allTotals),
  ])) {
    const current = currentTotals[key] || 0;
    const prev = previousTotals[key] || 0;
    const avg = (allTotals[key] || 0) / Math.max(monthsCovered, 1);
    let projected;
    if (current > 0 && prev > 0) {
      projected = current + (current - prev) * 0.35;
    } else if (current > 0) {
      projected = current * 1.05;
    } else if (prev > 0) {
      projected = prev * 0.82;
    } else {
      projected = avg;
    }
    const raw = Math.max(0, current * 0.55 + Math.max(0, projected) * 0.25 + avg * 0.2);
    rawTotals[key] = raw;
    rawGrandTotal += raw;
  }

  if (rawGrandTotal <= 0) {
    return rawPrediction;
  }

  return (rawPrediction / rawGrandTotal) * predictedNext;
}

function sumByCategory(transactions) {
  const totals = {};
  for (const tx of transactions) {
    totals[tx.categoryKey] = (totals[tx.categoryKey] || 0) + tx.amount;
  }
  return totals;
}

function sumAmounts(transactions) {
  return transactions.reduce((sum, tx) => sum + tx.amount, 0);
}

function historyMonths(transactions, now) {
  if (!transactions.length) {
    return 1;
  }

  const oldest = transactions.reduce(
    (minDate, tx) => (tx.date < minDate ? tx.date : minDate),
    transactions[0].date,
  );
  const coveredDays = Math.max(1, Math.floor((now - oldest) / (1000 * 60 * 60 * 24)) + 1);
  return Math.max(1, coveredDays / 30);
}

function normalizeCategory(value) {
  const normalized = String(value || 'other').trim().toLowerCase();
  if (!normalized || normalized === 'others') {
    return 'other';
  }
  return normalized;
}

function toAmount(value) {
  const amount = Number(value || 0);
  return Number.isFinite(amount) ? amount : 0;
}

function formatCurrency(value) {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0,
  }).format(value || 0);
}

function titleCase(value) {
  const normalized = normalizeCategory(value);
  return normalized.charAt(0).toUpperCase() + normalized.slice(1);
}

function todayKey() {
  const now = new Date();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${now.getFullYear()}-${month}-${day}`;
}



