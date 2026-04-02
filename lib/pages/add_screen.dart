import 'package:finova_ai/models/category_selector_model.dart';
import 'package:finova_ai/models/payment_method.dart';
import 'package:finova_ai/models/transactions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finova_ai/providers/history_provider.dart';
import 'package:finova_ai/widgets/category_selector.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:finova_ai/widgets/payment_methodsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  String selectedCategory = "Food";
  DateTime selectedDateTime = DateTime.now();

  CategorySelectorModel selectedCategoryModel = CategorySelectorModel(
    title: "Food",
    imagePath: "assets/diet.png",
  );

  PaymentMethod selectedPayment = PaymentMethod(
    title: "Cash",
    imagePath: "assets/money.png",
  );

  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  Future<void> saveExpenseToFirestore(TransactionModel2 transaction) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .add({
          "category": transaction.category.toLowerCase(),
          "title": transaction.title,
          "amount": transaction.amount,
          "paymentMethod": transaction.paymentTitle,
          "date": transaction.dateTime,
        });
  }

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
        ),
        title: const Text("Add Expense"),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
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
                        hintText: "00.00",
                        hintStyle: TextStyle(color: Colors.grey.shade300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        final result =
                            await showModalBottomSheet<CategorySelectorModel>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              builder:
                                  (_) => CategorySelector(
                                    initialMethod: selectedCategoryModel,
                                  ),
                            );

                        if (result != null) {
                          setState(() {
                            selectedCategoryModel = result;
                            selectedCategory = result.title;
                          });
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              selectedCategoryModel.imagePath,
                              height: 22,
                              width: 22,
                            ),

                            const SizedBox(width: 12),

                            Text(
                              selectedCategoryModel.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Spacer(),

                            const Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: pickDateTime,
                      child: _inputBox(
                        icon: Icons.calendar_today,
                        text:
                            "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} | ${selectedDateTime.hour}:${selectedDateTime.minute.toString().padLeft(2, '0')}",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: titleController,
                      decoration: _inputDecoration("Title"),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        final result =
                            await showModalBottomSheet<PaymentMethod>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              builder:
                                  (_) => PaymentMethodSheet(
                                    initialMethod: selectedPayment,
                                  ),
                            );

                        if (result != null) {
                          setState(() {
                            selectedPayment = result;
                          });
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              selectedPayment.imagePath,
                              height: 22,
                              width: 22,
                            ),

                            const SizedBox(width: 12),

                            Text(
                              selectedPayment.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Spacer(),

                            const Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          10,
          screenWidth * 0.05,
          MediaQuery.of(context).viewInsets.bottom == 0
              ? 80
              : MediaQuery.of(context).viewInsets.bottom + 4,
        ),
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButtonCust('Save Expense', () async {
                FocusScope.of(context).unfocus();

                if (amountController.text.isEmpty ||
                    titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                final newTransaction = TransactionModel2(
                  id: DateTime.now().toString(),
                  category: selectedCategory,
                  title: titleController.text,
                  amount: double.parse(amountController.text),
                  dateTime: selectedDateTime,
                  paymentTitle: selectedPayment.title,
                  paymentImage: selectedPayment.imagePath,
                );

                await saveExpenseToFirestore(newTransaction);

                ref
                    .read(transactionsProvider.notifier)
                    .addTransaction(newTransaction);

                if (!mounted) return;
                Navigator.pop(context, newTransaction);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Widget _inputBox({
    required IconData icon,
    required String text,
    IconData? trailing,
  }) {
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
          if (trailing != null) Icon(trailing),
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
      hintStyle: TextStyle(color: Colors.grey.shade300),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
