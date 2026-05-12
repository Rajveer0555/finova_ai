import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/providers/budget_provider.dart';
import 'package:finova_ai/providers/income_provider.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:finova_ai/services/finova_ai_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiInsightProvider = Provider<AiInsightResult>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);
  final budgetAsync = ref.watch(budgetProvider);
  final incomeAsync = ref.watch(monthlyIncomeProvider);

  final snapshot = transactionsAsync.value;
  if (snapshot == null) {
    return AiInsightResult.empty();
  }

  final budgetMap = <String, double>{};
  final budgetDoc = budgetAsync.value;
  final rawBudgets = budgetDoc?.data()?['budgets'];
  if (rawBudgets is Map) {
    for (final entry in rawBudgets.entries) {
      budgetMap[_normalizeCategoryKey(entry.key)] = _readAmount(entry.value);
    }
  }

  final income = incomeAsync.maybeWhen(
    data: (value) => value,
    orElse: () => 0.0,
  );

  final transactions = <AiInputTransaction>[];

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final date = _readDate(data['date']);
    if (date == null) {
      continue;
    }

    transactions.add(
      AiInputTransaction(
        title: (data['title'] ?? '').toString(),
        categoryKey: _normalizeCategoryKey(data['category']),
        amount: _readAmount(data['amount']),
        date: date,
      ),
    );
  }

  try {
    return FinovaAiEngine.build(
      transactions: transactions,
      budgets: budgetMap,
      monthlyIncome: income,
      now: DateTime.now(),
    );
  } catch (_) {
    try {
      return FinovaAiEngine.build(
        transactions: transactions,
        budgets: const <String, double>{},
        monthlyIncome: 0.0,
        now: DateTime.now(),
      );
    } catch (_) {
      return AiInsightResult.empty();
    }
  }
});

double _readAmount(dynamic value) {
  if (value is num && value.isFinite) {
    return value.toDouble();
  }
  if (value is num) {
    return value.toDouble();
  }

  final parsed = double.tryParse(value?.toString() ?? '') ?? 0.0;
  if (!parsed.isFinite) {
    return 0.0;
  }
  return parsed;
}

DateTime? _readDate(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  return null;
}

String _normalizeCategoryKey(dynamic value) {
  final normalized = value?.toString().trim().toLowerCase() ?? 'other';
  if (normalized.isEmpty || normalized == 'others') {
    return 'other';
  }
  return normalized;
}
