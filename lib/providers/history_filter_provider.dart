import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class HistoryFilterState {
  final String? paymentMethod;
  final String? category;
  final DateTimeRange? dateRange;

  const HistoryFilterState({
    this.paymentMethod,
    this.category,
    this.dateRange,
  });

  HistoryFilterState copyWith({
    String? paymentMethod,
    String? category,
    DateTimeRange? dateRange,
  }) {
    return HistoryFilterState(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      category: category ?? this.category,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

class HistoryFilterNotifier extends StateNotifier<HistoryFilterState> {
  HistoryFilterNotifier() : super(const HistoryFilterState());

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setDateRange(DateTimeRange range) {
    state = state.copyWith(dateRange: range);
  }

  void reset() {
    state = const HistoryFilterState();
  }
}

final historyFilterProvider =
    StateNotifierProvider<HistoryFilterNotifier, HistoryFilterState>(
  (ref) => HistoryFilterNotifier(),
);
