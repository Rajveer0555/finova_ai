import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'month_group_provider.dart';

final monthTotalProvider = Provider<Map<String, double>>((ref) {
  final grouped = ref.watch(groupedByMonthProvider);

  return grouped.map((key, list) {
    final total = list.fold(0.0, (sum, t) => sum + t.amount);
    return MapEntry(key, total);
  });
});
