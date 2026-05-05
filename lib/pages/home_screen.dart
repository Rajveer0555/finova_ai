import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finova_ai/pages/ai_insights_screen.dart';
import 'package:finova_ai/pages/statesScreens/error_state.dart';
import 'package:finova_ai/pages/statesScreens/loading_state.dart';
import 'package:finova_ai/pages/statesScreens/no_internet_screen.dart';
import 'package:finova_ai/providers/ai_insight_provider.dart';
import 'package:finova_ai/providers/bottom_nav_provider.dart';
import 'package:finova_ai/providers/budget_provider.dart';
import 'package:finova_ai/providers/category_provider.dart';
import 'package:finova_ai/providers/connectivity_provider.dart';
import 'package:finova_ai/providers/income_provider.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:finova_ai/services/finova_ai_engine.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:finova_ai/utils/page_transitions.dart';
import 'package:finova_ai/widgets/mainscreen_catgerories.dart';
import 'package:finova_ai/widgets/shimmer_skeleton.dart';
import 'package:finova_ai/widgets/user_avatar.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _startupRefreshTimer;
  bool _startupRefreshQueued = false;

  @override
  void dispose() {
    _startupRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final incomeAsync = ref.watch(monthlyIncomeProvider);
    final income = incomeAsync.maybeWhen(
      data: (value) => value,
      orElse: () => 0.0,
    );

    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final budgetAsync = ref.watch(budgetProvider);
    final connectivityAsync = ref.watch(connectivityProvider);
    final categories = ref.watch(categoriesProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final needsInitialHydration =
        (transactionsAsync.isLoading && !transactionsAsync.hasValue) ||
        (incomeAsync.isLoading && !incomeAsync.hasValue) ||
        (budgetAsync.isLoading && !budgetAsync.hasValue);

    if (needsInitialHydration) {
      _queueStartupRefresh();
      return const _HomeSkeletonState();
    }

    return transactionsAsync.when(
      data: (snapshot) {
        final docs = snapshot.docs;
        final referenceDate = _referenceDateFromDocs(docs);
        final startOfCurrentMonth = DateTime(
          referenceDate.year,
          referenceDate.month,
          1,
        );
        final startOfLastMonth = DateTime(
          referenceDate.year,
          referenceDate.month - 1,
          1,
        );
        final activeMonthLabel = _formatMonthYear(referenceDate);
        AiInsightResult ai;
        try {
          ai = ref.watch(aiInsightProvider);
        } catch (_) {
          ai = AiInsightResult.empty();
        }
        double totalExpense = 0;
        final rawBudgets = budgetAsync.value?.data()?['budgets'];
        final normalizedBudgets = <String, double>{};
        if (rawBudgets is Map) {
          for (final entry in rawBudgets.entries) {
            final key = _normalizeCategoryKey(entry.key);
            final value = _readAmount(entry.value);
            normalizedBudgets[key] = value;
          }
        }
        final totalBudget = normalizedBudgets.values.fold<double>(
          0.0,
          (sum, value) => sum + value,
        );

        final Map<String, double> categoryTotals = {};
        final Map<String, int> categoryCounts = {};
        final Map<String, double> lastMonthCategoryTotals = {};

        for (final doc in docs) {
          final data = doc.data();
          final amount = _readAmount(data['amount']);
          final category = _normalizeCategoryKey(data['category']);
          final date = _readDate(data['date']);
          if (date == null) {
            continue;
          }

          if (date.isAfter(
            startOfCurrentMonth.subtract(const Duration(days: 1)),
          )) {
            totalExpense += amount;
            categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
            categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
          }

          if (date.isAfter(
                startOfLastMonth.subtract(const Duration(days: 1)),
              ) &&
              date.isBefore(startOfCurrentMonth)) {
            lastMonthCategoryTotals[category] =
                (lastMonthCategoryTotals[category] ?? 0) + amount;
          }
        }

        final double usage =
            income <= 0
                ? 0.0
                : (totalExpense / income).clamp(0.0, 1.0).toDouble();
        final incomeDifference = income - totalExpense;
        final String incomeStatusText;
        if (income <= 0) {
          incomeStatusText = "Set your monthly income to track remaining";
        } else if (incomeDifference >= 0) {
          incomeStatusText =
              "${formatCurrency(incomeDifference)} remaining from income of ${formatCurrency(income)}";
        } else {
          incomeStatusText =
              "${formatCurrency(incomeDifference.abs())} more than income of ${formatCurrency(income)}";
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                  formatCurrency(totalExpense),
                                  style: const TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  activeMonthLabel,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                ref
                                    .read(bottomNavIndexProvider.notifier)
                                    .state = 3;
                              },
                              child: const UserAvatar(radius: 28),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
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
                                      formatPercentage(usage * 100),
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
                                  incomeStatusText,
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
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.035,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        buildSlideFromRightRoute(const AiInsightsScreen()),
                      );
                    },
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
                            const Icon(
                              Icons.lightbulb,
                              color: Colors.yellow,
                              size: 30,
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'AI Insights',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.004),
                                  Text(
                                    ai.homePreviewText,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w300,
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
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.035,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final key = category.id.toLowerCase();
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
                              onTap: () {
                                ref
                                    .read(bottomNavIndexProvider.notifier)
                                    .state = 2;
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: screenHeight * 0.16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        _queueStartupRefresh();
        return const _HomeSkeletonState();
      },
      error: (e, _) {
        return connectivityAsync.when(
          data: (connectivity) {
            if (connectivity == ConnectivityResult.none) {
              return NoInternetScreen(
                onRetry: () => ref.invalidate(transactionsStreamProvider),
              );
            }

            return ErrorStateScreen(
              onRetry: () => ref.invalidate(transactionsStreamProvider),
            );
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

  void _queueStartupRefresh() {
    if (_startupRefreshQueued) {
      return;
    }

    _startupRefreshQueued = true;
    _startupRefreshTimer?.cancel();
    _startupRefreshTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) {
        return;
      }

      ref.invalidate(transactionsStreamProvider);
      ref.invalidate(monthlyIncomeProvider);
      ref.invalidate(budgetProvider);
      _startupRefreshQueued = false;
    });
  }
}

class _HomeSkeletonState extends StatelessWidget {
  const _HomeSkeletonState();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(31, 112, 112, 112),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: ShimmerSkeleton(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.08),
                      Row(
                        children: const [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonBox(height: 14, width: 110, radius: 8),
                                SizedBox(height: 10),
                                SkeletonBox(height: 40, width: 180, radius: 12),
                                SizedBox(height: 8),
                                SkeletonBox(height: 14, width: 80, radius: 8),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFE9EDF3),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SkeletonBox(height: 14, width: 90, radius: 8),
                                  Spacer(),
                                  SkeletonBox(height: 20, width: 54, radius: 8),
                                ],
                              ),
                              SizedBox(height: 12),
                              SkeletonBox(height: 10, width: double.infinity, radius: 12),
                              SizedBox(height: 10),
                              SkeletonBox(height: 12, width: 200, radius: 8),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
              child: ShimmerSkeleton(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBED),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(0xFFE9EDF3),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonBox(height: 16, width: 100, radius: 8),
                                  SizedBox(height: 8),
                                  SkeletonBox(height: 12, width: 220, radius: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: SkeletonBox(height: 18, width: 100, radius: 8),
                    ),
                    const SizedBox(height: 14),
                    for (int i = 0; i < 4; i++) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(0xFFE9EDF3),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonBox(height: 14, width: 120, radius: 8),
                                  SizedBox(height: 8),
                                  SkeletonBox(height: 12, width: 170, radius: 8),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            SkeletonBox(height: 16, width: 60, radius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    SizedBox(height: screenHeight * 0.16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DateTime _referenceDateFromDocs(
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
) {
  DateTime? latest;

  for (final doc in docs) {
    final date = _readDate(doc.data()['date']);
    if (date == null) {
      continue;
    }
    if (latest == null || date.isAfter(latest)) {
      latest = date;
    }
  }

  return latest ?? DateTime.now();
}

String _formatMonthYear(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.year}';
}

double _readAmount(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

DateTime? _readDate(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  return null;
}

String _normalizeCategoryKey(dynamic value) {
  final normalized = value?.toString().trim().toLowerCase() ?? 'other';
  if (normalized.isEmpty || normalized == 'others') {
    return 'other';
  }
  return normalized;
}
