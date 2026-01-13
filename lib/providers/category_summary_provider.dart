import 'package:finova_ai/models/category_summary.dart';
import 'package:finova_ai/providers/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categorySummaryProvider = Provider<Map<String, CategorySummary>>((ref) {
  final transactions = ref.watch(transactionsProvider);

  final Map<String, CategorySummary> summary = {};

  for (final t in transactions) {
    if (!summary.containsKey(t.category)) {
      summary[t.category] = CategorySummary(count: 0, totalAmount: 0.0);
    }

    summary[t.category] = CategorySummary(
      count: summary[t.category]!.count + 1,
      totalAmount: summary[t.category]!.totalAmount + t.amount,
    );
  }

  return summary;
});
