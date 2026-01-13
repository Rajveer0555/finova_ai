import 'package:finova_ai/models/history_model.dart';
import 'package:flutter_riverpod/legacy.dart';

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
      (ref) => TransactionsNotifier(),
    );

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionsNotifier() : super([]);

  void addTransaction(TransactionModel transaction) {
    state = [transaction, ...state]; // newest first
  }

  void removeTransaction(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}
