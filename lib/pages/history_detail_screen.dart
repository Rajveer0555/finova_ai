import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/pages/edit_screen.dart';
import 'package:finova_ai/providers/history_provider.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final TransactionModel2 transaction;

  const ExpenseDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = transaction;
    double screenHeight = MediaQuery.of(context).size.height;

    void showDeleteDialog(
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
                height: screenHeight * 0.20,
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

                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      "This action cannot be undo.",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SFProText',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Expense Detail"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(_getCategoryImage(t.category), height: 46),
                  const SizedBox(height: 8),

                  Text(
                    t.category.isNotEmpty
                        ? t.category[0].toUpperCase() + t.category.substring(1)
                        : "Other",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Text(
                          formatCurrency(t.amount),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t.title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _infoBox(
                    icon: Icons.calendar_today,
                    text:
                        "${t.dateTime.day}/${t.dateTime.month}/${t.dateTime.year} | ${t.dateTime.hour}:${t.dateTime.minute.toString().padLeft(2, '0')}",
                  ),

                  const SizedBox(height: 12),

                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          getPaymentImage(t.paymentTitle),
                          height: 22,
                        ),

                        const SizedBox(width: 12),

                        Text(
                          t.paymentTitle.isNotEmpty
                              ? t.paymentTitle[0].toUpperCase() +
                                  t.paymentTitle.substring(1)
                              : "Unknown",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const Spacer(),

                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            RichText(
              text: TextSpan(
                text:
                    "🤖 Pro tip : Track your expenses consistently for better insights",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: "SFProText",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EditTransactionScreen(transaction: t),
                          ),
                        );
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        showDeleteDialog(context, ref, t);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case "food":
        return "assets/diet.png";
      case "travel":
        return "assets/travel-luggage.png";
      case "bills":
        return "assets/bill.png";
      case "shopping":
        return "assets/shopping-bag.png";
      case "other":
      case "others":
        return "assets/delivery-box.png";
      default:
        return "assets/delivery-box.png";
    }
  }

  String getPaymentImage(String method) {
    switch (method.toLowerCase()) {
      case "cash":
        return "assets/money.png";
      case "credit card":
        return "assets/credit-card.png";
      case "debit card":
        return "assets/contactless.png";
      case "wallet":
        return "assets/ewallet.png";
      default:
        return "assets/ewallet.png";
    }
  }

  Widget _infoBox({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
