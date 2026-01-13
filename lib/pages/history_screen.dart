import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/pages/edit_screen.dart';
import 'package:finova_ai/pages/history_detail_screen.dart';
import 'package:finova_ai/providers/history_provider.dart';
import 'package:finova_ai/providers/total_expense_provider.dart';
import 'package:finova_ai/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _goToEditScreen(
      BuildContext context,
      TransactionModel2 transaction,
    ) async {
      final updatedTransaction = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditTransactionScreen(transaction: transaction),
        ),
      );

      if (updatedTransaction != null) {
        ref
            .read(transactionsProvider.notifier)
            .updateTransaction(updatedTransaction);
      }
    }

    final totalExpense = ref.watch(totalExpenseProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void _showDeleteDialog(
      BuildContext context,
      WidgetRef ref,
      TransactionModel2 transaction,
    ) {
      showDialog(
        context: context,
        builder:
            (context) => Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                height: screenHeight * 0.18,
                width: 280,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 12),
                    Icon(Icons.delete_outlined, color: Colors.red),
                    SizedBox(height: 10),
                    Text(
                      "Delete this Expense ?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "This action cannot be undo.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.black12, width: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            ref
                                .read(transactionsProvider.notifier)
                                .removeTransaction(transaction.id);

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
      );
    }

    final transactions = ref.watch(timeSortedTransactionsProvider);

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Recent Transactions',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFProText',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    final current = ref.read(timeSortOrderProvider);
                    ref.read(timeSortOrderProvider.notifier).state = !current;
                  },
                  icon: const Icon(Icons.swap_vert),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.format_list_bulleted),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Slidable(
                        key: ValueKey(transactions[index].id),
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: (context) {
                                _goToEditScreen(context, transactions[index]);
                              },
                              backgroundColor: Colors.lightBlue.shade50,
                              foregroundColor: Colors.blue.shade400,
                              icon: Icons.edit_square,
                              label: 'Edit',
                            ),
                            SizedBox(width: 6),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SizedBox(width: 6),
                            SlidableAction(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: (context) {
                                _showDeleteDialog(
                                  context,
                                  ref,
                                  transactions[index],
                                );
                              },
                              backgroundColor: Colors.red.shade100,
                              foregroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: TransactionCard(
                          transaction: transactions[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ExpenseDetailScreen(
                                      transaction: transactions[index],
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
