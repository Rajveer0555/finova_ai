import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'filtered_history_provider.dart';
import '../models/transactions_model.dart';

final filteredGroupedByMonthProvider =
    Provider<List<MapEntry<DateTime, List<TransactionModel2>>>>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);

  final Map<DateTime, List<TransactionModel2>> grouped = {};

  for (final tx in transactions) {
    final key = DateTime(tx.dateTime.year, tx.dateTime.month);
    grouped.putIfAbsent(key, () => []);
    grouped[key]!.add(tx);
  }

  final entries = grouped.entries.toList()
    ..sort((a, b) => b.key.compareTo(a.key)); // 🔥 latest month first

  return entries;
});
