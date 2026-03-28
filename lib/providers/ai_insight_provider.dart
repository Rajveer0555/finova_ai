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
      budgetMap[entry.key.toString()] = (entry.value as num?)?.toDouble() ?? 0;
    }
  }

  final income = incomeAsync.maybeWhen(
    data: (value) => value,
    orElse: () => 0.0,
  );

  final transactions = <AiInputTransaction>[];
  DateTime? latestTransactionDate;

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final date = _readDate(data['date']);
    if (date == null) {
      continue;
    }
    if (latestTransactionDate == null || date.isAfter(latestTransactionDate)) {
      latestTransactionDate = date;
    }

    transactions.add(
      AiInputTransaction(
        title: (data['title'] ?? '').toString(),
        categoryKey: (data['category'] ?? 'other').toString(),
        amount: _readAmount(data['amount']),
        date: date,
      ),
    );
  }

  return FinovaAiEngine.build(
    transactions: transactions,
    budgets: budgetMap,
    monthlyIncome: income,
    now: latestTransactionDate ?? DateTime.now(),
  );
});

double _readAmount(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0.0;
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
