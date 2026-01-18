import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/providers/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final groupedByMonthProvider = Provider<Map<String, List<TransactionModel2>>>((
  ref,
) {
  final transactions = ref.watch(transactionsProvider);

  final Map<String, List<TransactionModel2>> grouped = {};

  for (final t in transactions) {
    final key = DateFormat('yyyy MMMM').format(t.dateTime); // 2026 January

    grouped.putIfAbsent(key, () => []);
    grouped[key]!.add(t);
  }

  return grouped;
});
