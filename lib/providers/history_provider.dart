import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/transactions_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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
