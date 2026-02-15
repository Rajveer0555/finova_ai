import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/providers/payment_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final timeSortOrderProvider = StateProvider<bool>((ref) {
  return true; // true = Newest first, false = Oldest first
});

final timeSortedTransactionsProvider = Provider<List<TransactionModel2>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final isNewestFirst = ref.watch(timeSortOrderProvider);

  final sortedList = [...transactions];

  sortedList.sort((a, b) {
    if (isNewestFirst) {
      return b.dateTime.compareTo(a.dateTime); // Newest → Oldest
    } else {
      return a.dateTime.compareTo(b.dateTime); // Oldest → Newest
    }
  });

  return sortedList;
});

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<TransactionModel2>>(
      (ref) => TransactionsNotifier(),
    );

class TransactionsNotifier extends StateNotifier<List<TransactionModel2>> {
  TransactionsNotifier() : super([]);

  void addTransaction(TransactionModel2 transaction) {
    state = [...state, transaction];
  }

  void removeTransaction(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void updateTransaction(TransactionModel2 updated) {
    state = [
      for (final t in state)
        if (t.id == updated.id) updated else t,
    ];
  }
}

final filteredTransactionsProvider = Provider((ref) {
  final transactions = ref.watch(transactionsProvider);

  final filter = ref.watch(paymentFilterProvider);

  if (filter == null) {
    return transactions;
  }

  return transactions.where((tx) => tx.paymentTitle == filter).toList();
});
