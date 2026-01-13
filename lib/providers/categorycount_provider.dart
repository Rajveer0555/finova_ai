import 'package:finova_ai/providers/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryCountProvider = Provider<Map<String, int>>((ref) {
  final transactions = ref.watch(transactionsProvider);

  final Map<String, int> counts = {};

  for (final t in transactions) {
    counts[t.category] = (counts[t.category] ?? 0) + 1;
  }

  return counts;
});
