import 'package:finova_ai/providers/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);

  double total = 0;
  for (final t in transactions) {
    total += t.amount;
  }

  return total;
});
