import 'package:flutter_riverpod/legacy.dart';

final budgetAmountProvider = StateProvider.family<double, String>((ref, id) {
  return 0.0;
});
