import 'package:finova_ai/providers/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_filter_provider.dart';
import '../models/transactions_model.dart';

final filteredTransactionsProvider =
    Provider<List<TransactionModel2>>((ref) {
  final filters = ref.watch(historyFilterProvider);
  final allTransactions = ref.watch(transactionsProvider); // ✅ FIX

  return allTransactions.where((tx) {
    // Payment Method Filter
    if (filters.paymentMethod != null &&
        filters.paymentMethod != filters.paymentMethod) {
      return false;
    }

    // Category Filter
    if (filters.category != null &&
        tx.category != filters.category) {
      return false;
    }

    // Date Range Filter
    // if (filters.dateRange != null) {
    //   if (tx.dateTime.isBefore(filters.dateRange!.start) ||
    //       tx.dateTime.isAfter(filters.dateRange!.end)) {
    //     return false;
    //   }
    // }

    return true;
  }).toList();
});
