import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finova_ai/pages/statesScreens/error_state.dart';
import 'package:finova_ai/pages/statesScreens/loading_state.dart';
import 'package:finova_ai/pages/statesScreens/no_internet_screen.dart';
import 'package:finova_ai/providers/connectivity_provider.dart';
import 'package:finova_ai/providers/income_provider.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finova_ai/providers/budget_provider.dart';
import 'package:finova_ai/providers/category_provider.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:finova_ai/widgets/mainscreen_catgerories.dart';
import 'package:finova_ai/widgets/userAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();

    DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime startOfLastMonth = DateTime(now.year, now.month - 1, 1);
    DateTime endOfLastMonth = startOfCurrentMonth.subtract(Duration(days: 1));
    final incomeAsync = ref.watch(monthlyIncomeProvider);

    final income = incomeAsync.maybeWhen(
      data: (value) => value,
      orElse: () => 0.0,
    );

    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final budgetAsync = ref.watch(budgetProvider);
    final connectivityAsync = ref.watch(connectivityProvider);
    final categories = ref.watch(categoriesProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return transactionsAsync.when(
      data: (snapshot) {
        return budgetAsync.when(
          data: (budgetDoc) {
            final docs = snapshot.docs;

            double totalExpense = 0;

            Map<String, double> categoryTotals = {};
            Map<String, int> categoryCounts = {};
            Map<String, double> lastMonthCategoryTotals = {};

            for (var doc in docs) {
              final data = doc.data();

              double amount = (data['amount'] as num).toDouble();
              String category = data['category'].toString().toLowerCase();

              DateTime date = (data['date'] as Timestamp).toDate();

              /// CURRENT MONTH
              if (date.isAfter(
                startOfCurrentMonth.subtract(const Duration(days: 1)),
              )) {
                totalExpense += amount;

                categoryTotals[category] =
                    (categoryTotals[category] ?? 0) + amount;
                categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
              }

              /// LAST MONTH
              if (date.isAfter(
                    startOfLastMonth.subtract(const Duration(days: 1)),
                  ) &&
                  date.isBefore(startOfCurrentMonth)) {
                lastMonthCategoryTotals[category] =
                    (lastMonthCategoryTotals[category] ?? 0) + amount;
              }
            }

            Map<String, dynamic> budgets = Map<String, dynamic>.from(
              budgetDoc.data()?['budgets'] ?? {},
            );

            double totalBudget = budgets.values.fold(
              0,
              (sum, item) => sum + (item ?? 0),
            );

            double usage =
                income == 0 ? 0 : (totalExpense / income).clamp(0, 1);

            double remaining = income - totalExpense;

            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(31, 112, 112, 112),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      width: screenWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.08),

                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total Spendings",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),

                                    Text(
                                      "${formatCurrency(totalExpense)}",
                                      style: const TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const Text(
                                      "This month",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                const UserAvatar(radius: 28),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            /// BUDGET CARD
                            Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.01,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Budgets Used",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${formatPercentage(usage * 100)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(12),
                                      minHeight: 10,
                                      value: usage,
                                      backgroundColor: Colors.grey.shade300,
                                      color:
                                          usage < 0.5
                                              ? Colors.green
                                              : usage < 0.8
                                              ? Colors.orange
                                              : Colors.red,
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      "${formatCurrency(remaining)} remaining of ${formatCurrency(income)}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.035,
                      ),
                      child: Container(
                        width: screenWidth * 0.92,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 251, 237),
                          border: Border.all(
                            color: Colors.amber.shade100,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.02,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Colors.yellow,
                                size: 30,
                              ),

                              SizedBox(width: screenWidth * 0.04),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'AI Insights',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'SFProText',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.004),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            'Your food expenses are 30% higher than last month. Consider meal planning to save ₹2,000',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'SFProText',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    /// CATEGORY SECTION
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.035,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 2),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final key = category.title.toLowerCase();

                              final transactionCount = categoryCounts[key] ?? 0;

                              final totalAmount = categoryTotals[key] ?? 0;

                              final lastMonthAmount =
                                  lastMonthCategoryTotals[key] ?? 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: MainscreenCatgerories(
                                  lastMonthAmount: lastMonthAmount,
                                  category: category,
                                  transactionCount: transactionCount,
                                  totalAmount: totalAmount,
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

          loading: () => const LoadingState(),

          error: (e, _) {
            return connectivityAsync.when(
              data: (connectivity) {
                if (connectivity == ConnectivityResult.none) {
                  return NoInternetScreen(
                    onRetry: () => ref.invalidate(budgetProvider),
                  );
                } else {
                  return ErrorStateScreen(
                    onRetry: () => ref.invalidate(budgetProvider),
                  );
                }
              },
              loading: () => const LoadingState(),
              error:
                  (_, __) => ErrorStateScreen(
                    onRetry: () => ref.invalidate(budgetProvider),
                  ),
            );
          },
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
          error:
              (_, __) => ErrorStateScreen(
                onRetry: () => ref.invalidate(transactionsStreamProvider),
              ),
        );
      },
    );
  }
}
