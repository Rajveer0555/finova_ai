import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finova_ai/models/category_selector_model.dart';
import 'package:finova_ai/models/payment_method.dart';
import 'package:finova_ai/pages/statesScreens/error_state.dart';
import 'package:finova_ai/pages/statesScreens/loading_state.dart';
import 'package:finova_ai/pages/statesScreens/no_internet_screen.dart';
import 'package:finova_ai/providers/connectivity_provider.dart';
import 'package:finova_ai/providers/history_filter_provider.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:finova_ai/widgets/category_selector.dart';
import 'package:finova_ai/widgets/month_history_card.dart';
import 'package:finova_ai/widgets/outlined_btn.dart';
import 'package:finova_ai/widgets/payment_methodsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final filters = ref.watch(historyFilterProvider);
    final connectivityAsync = ref.watch(connectivityProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return transactionsAsync.when(
      data: (snapshot) {
        final docs = snapshot.docs;
        Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
        for (var doc in docs) {
          final data = doc.data();

          DateTime date = (data['date'] as Timestamp).toDate();

          String monthKey = "${date.year}-${date.month}";

          if (!groupedTransactions.containsKey(monthKey)) {
            groupedTransactions[monthKey] = [];
          }

          groupedTransactions[monthKey]!.add(data);
        }

        double totalExpense = 0;
        Map<String, List<QueryDocumentSnapshot>> grouped = {};

        for (var doc in docs) {
          final data = doc.data();

          double amount = (data['amount'] ?? 0).toDouble();

          Timestamp? ts = data['date'];
          if (ts == null) continue;

          DateTime date = ts.toDate();

          String category = data['category']?.toString() ?? '';
          String paymentMethod = data['paymentMethod']?.toString() ?? '';

          /// CATEGORY FILTER
          if (filters.category != null) {
            if (category.toLowerCase() != filters.category!.toLowerCase()) {
              continue;
            }
          }

          /// PAYMENT METHOD FILTER
          if (filters.paymentMethod != null) {
            if (paymentMethod.toLowerCase() !=
                filters.paymentMethod!.toLowerCase()) {
              continue;
            }
          }

          /// DATE RANGE FILTER
          if (filters.dateRange != null) {
            final start = filters.dateRange!.start;
            final end = filters.dateRange!.end.add(const Duration(days: 1));

            if (date.isBefore(start) || date.isAfter(end)) {
              continue;
            }
          }

          totalExpense += amount;

          String monthKey = "${date.year}-${date.month}";

          grouped.putIfAbsent(monthKey, () => []);
          grouped[monthKey]!.add(doc);
        }

        final groupedList = grouped.entries.toList();

        // Ensure current month is always shown at the top
        DateTime now = DateTime.now();
        String currentMonthKey = "${now.year}-${now.month}";
        if (!grouped.containsKey(currentMonthKey)) {
          grouped[currentMonthKey] = [];
          groupedList.add(MapEntry(currentMonthKey, []));
        }

        // Sort: current month first, then others in descending order
        groupedList.sort((a, b) {
          if (a.key == currentMonthKey) return -1;
          if (b.key == currentMonthKey) return 1;
          return b.key.compareTo(a.key);
        });

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              /// HEADER
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  color: Color(0xFF4A90FF),
                ),
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.08),

                      const Text(
                        'Expenses History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SFProText',
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      /// TOTAL EXPENSE CARD
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: const Color.fromARGB(255, 100, 159, 255),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.015,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Expenses',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'SFProText',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatCurrency(totalExpense),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SFProText',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              /// FILTER BUTTONS
              SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    OutlinedBtn(
                      title: 'Payment Method',
                      onTap:
                          () async =>
                              await showPaymentMethodSheet(context, ref),
                    ),
                    const SizedBox(width: 10),
                    OutlinedBtn(
                      title: 'Category',
                      onTap: () async => await showCategorySheet(context, ref),
                    ),
                    const SizedBox(width: 10),
                    OutlinedBtn(
                      title: 'Date',
                      onTap: () => showDateRangeSheet(context, ref),
                    ),
                    OutlinedBtn(
                      title: 'Reset',
                      onTap: () {
                        ref.read(historyFilterProvider.notifier).reset();
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              /// TRANSACTION LIST
              Expanded(
                child:
                    groupedList.isEmpty
                        ? const Center(
                          child: Text(
                            "No transactions yet",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 120),
                          itemCount: groupedList.length,
                          itemBuilder: (context, index) {
                            final e = groupedList[index];
                            return MonthHistoryCard(
                              monthKey: e.key,
                              transactions: e.value,
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },

      loading: () => const LoadingState(),

      error: (e, _) {
        return connectivityAsync.when(
          data: (connectivity) {
            if (connectivity == ConnectivityResult.none) {
              return NoInternetScreen(
                onRetry: () => ref.invalidate(transactionsStreamProvider),
              );
            } else {
              return ErrorStateScreen(
                onRetry: () => ref.invalidate(transactionsStreamProvider),
              );
            }
          },
          loading: () => const LoadingState(),
          error: (_, __) => ErrorStateScreen(
            onRetry: () => ref.invalidate(transactionsStreamProvider),
          ),
        );
      },
    );
  }
}

Future<void> showPaymentMethodSheet(BuildContext context, WidgetRef ref) async {
  final currentMethod = ref.read(historyFilterProvider).paymentMethod;
  final initialMethod = PaymentMethod(
    title: currentMethod ?? "Cash",
    imagePath: _paymentMethodIcon(currentMethod ?? "Cash"),
  );

  final result = await showModalBottomSheet<PaymentMethod>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => PaymentMethodSheet(initialMethod: initialMethod),
  );

  if (result != null) {
    ref.read(historyFilterProvider.notifier).setPaymentMethod(result.title);
  }
}

Future<void> showCategorySheet(BuildContext context, WidgetRef ref) async {
  final currentCategory = ref.read(historyFilterProvider).category;
  final initialCategory = CategorySelectorModel(
    title: currentCategory != null ? _capitalize(currentCategory) : "Food",
    imagePath: _categoryIcon(currentCategory ?? "food"),
  );

  final result = await showModalBottomSheet<CategorySelectorModel>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => CategorySelector(initialMethod: initialCategory),
  );

  if (result != null) {
    var selected = result.title.toLowerCase();
    if (selected == 'other') selected = 'others';
    ref.read(historyFilterProvider.notifier).setCategory(selected);
  }
}

void showDateRangeSheet(BuildContext context, WidgetRef ref) async {
  final range = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
  );

  if (range != null) {
    ref.read(historyFilterProvider.notifier).setDateRange(range);
  }
}

String _capitalize(String? input) {
  if (input == null || input.isEmpty) return '';
  final normalized = input.toLowerCase();
  if (normalized == 'others' || normalized == 'other') return 'Other';
  return normalized[0].toUpperCase() + normalized.substring(1);
}

String _categoryIcon(String? category) {
  switch (category?.toLowerCase()) {
    case 'food':
      return 'assets/diet.png';
    case 'travel':
      return 'assets/travel-luggage.png';
    case 'shopping':
      return 'assets/shopping-bag.png';
    case 'bills':
      return 'assets/bill.png';
    default:
      return 'assets/delivery-box.png';
  }
}

String _paymentMethodIcon(String? method) {
  switch (method?.toLowerCase()) {
    case 'cash':
      return 'assets/money.png';
    case 'debit card':
      return 'assets/contactless.png';
    case 'credit card':
      return 'assets/credit-card.png';
    case 'wallet':
      return 'assets/ewallet.png';
    default:
      return 'assets/money.png';
  }
}
