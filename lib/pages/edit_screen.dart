import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/providers/history_provider.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel2 transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  String getCategoryImage(String category) {
    final match = categories.firstWhere(
      (c) => c['title'] == category,
      orElse: () => {"image": "assets/diet.png"},
    );
    return match['image'];
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

  late TextEditingController amountController;
  late TextEditingController titleController;
  late String selectedCategory;
  late DateTime selectedDateTime;
  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    titleController = TextEditingController(text: widget.transaction.title);

    selectedCategory = widget.transaction.category; // 👈 IMPORTANT
    selectedDateTime = widget.transaction.dateTime;
  }

  final List<Map<String, dynamic>> categories = [
    {"title": "Food", "image": "assets/diet.png"},
    {"title": "Travel", "image": "assets/travel-luggage.png"},
    {"title": "Bills", "image": "assets/bill.png"},
    {"title": "Shopping", "image": "assets/shopping-bag.png"},
    {"title": "Other", "image": "assets/delivery-box.png"},
  ];

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        title: const Text("Edit Expense"),
        centerTitle: true,
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
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          getCategoryImage(selectedCategory),
                          height: 22,
                          width: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          selectedCategory,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _infoBox(
                    icon: Icons.calendar_today,
                    text:
                        "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} | "
                        "${selectedDateTime.hour}:${selectedDateTime.minute.toString().padLeft(2, '0')}",
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: titleController,
                    decoration: _inputDecoration("Title"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          getPaymentImage(widget.transaction.paymentTitle),
                          height: 22,
                          width: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.transaction.paymentTitle.isNotEmpty
                              ? widget.transaction.paymentTitle[0]
                                      .toUpperCase() +
                                  widget.transaction.paymentTitle.substring(1)
                              : "Cash",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green),
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            RichText(
              text: TextSpan(
                text: '🤖  Looks like a $selectedCategory expense',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProText',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButtonCust('Save Expense', () async {
                  final amount = double.tryParse(amountController.text);

                  if (amount == null || titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter valid amount and title"),
                      ),
                    );
                    return;
                  }

                  final updatedTransaction = widget.transaction.copyWith(
                    amount: amount,
                    title: titleController.text.trim(),
                  );

                  await ref
                      .read(transactionsProvider.notifier)
                      .updateTransaction(updatedTransaction);

                  if (context.mounted) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                }),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed:
                      () => showDeleteDialog(context, ref, widget.transaction),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
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

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );
}
