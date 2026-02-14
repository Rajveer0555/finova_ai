import 'package:finova_ai/providers/filtered_grouped_by_month_provider.dart';
import 'package:finova_ai/providers/history_filter_provider.dart';
import 'package:finova_ai/providers/month_total_provider.dart'
    show monthTotalProvider;
import 'package:finova_ai/providers/total_expense_provider.dart';
import 'package:finova_ai/widgets/month_history_card.dart';
import 'package:finova_ai/widgets/outlined_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = ref.watch(filteredGroupedByMonthProvider);

    final totalExpense = ref.watch(totalExpenseProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              color: Color(0xFF4A90FF),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(31, 112, 112, 112),
                  blurRadius: 12.0,
                  spreadRadius: 0,
                ),
              ],
            ),
            width: screenWidth * 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  RichText(
                    text: TextSpan(
                      text: 'Expenses History',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProText',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Color.fromARGB(255, 100, 159, 255),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.002),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    text: 'Total Expenses',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SFProText',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '₹ ${totalExpense.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SFProText',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                              ],
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
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              children: [
                OutlinedBtn(
                  title: 'Payment Method',
                  onTap: () => showPaymentMethodSheet(context),
                ),

                SizedBox(width: 10),
                OutlinedBtn(
                  title: 'Category',
                  onTap: () => showCategorySheet(context),
                ),
                SizedBox(width: 10),
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
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: ListView(
                children:
                    grouped.map((e) {
                      return MonthHistoryCard(
                        monthKey: e.key,
                        transactions: e.value,
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

void showPaymentMethodSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder:
        (_) => Consumer(
          builder: (context, ref, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ['Cash', 'Debit Card', 'Credit Card', 'Wallet']
                      .map(
                        (method) => ListTile(
                          title: Text(method),
                          onTap: () {
                            ref
                                .read(historyFilterProvider.notifier)
                                .setPaymentMethod(method);
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            );
          },
        ),
  );
}

void showCategorySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder:
        (_) => Consumer(
          builder: (context, ref, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ['Food', 'Travel', 'Shopping', 'Bills', 'Other']
                      .map(
                        (cat) => ListTile(
                          title: Text(cat),
                          onTap: () {
                            ref
                                .read(historyFilterProvider.notifier)
                                .setCategory(cat);
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            );
          },
        ),
  );
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
