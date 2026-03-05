import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/providers/payment_filter_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    StateNotifierProvider<TransactionsNotifier, List<TransactionModel2>>((ref) {
      return TransactionsNotifier();
    });

class TransactionsNotifier extends StateNotifier<List<TransactionModel2>> {
  TransactionsNotifier() : super([]);

  Future<void> updateTransaction(TransactionModel2 transaction) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(transaction.id)
        .update({
          "title": transaction.title,
          "amount": transaction.amount,
          "category": transaction.category,
          "paymentMethod": transaction.paymentTitle,
          "date": transaction.dateTime,
        });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> removeTransaction(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(id)
        .delete();
  }

  void addTransaction(TransactionModel2 transaction) {
    state = [...state, transaction];
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
