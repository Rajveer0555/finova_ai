import 'package:finova_ai/pages/main_navigation.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/providers/income_provider.dart';
import 'package:finova_ai/widgets/alerts_container.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:finova_ai/widgets/expense_adjust_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN', // Indian format
    symbol: '₹',
    decimalDigits: 0,
  );

  return formatter.format(amount);
}

class ManageBudgetScreen extends ConsumerStatefulWidget {
  const ManageBudgetScreen({super.key});

  @override
  ConsumerState<ManageBudgetScreen> createState() => _ManageBudgetScreenState();
}

class _ManageBudgetScreenState extends ConsumerState<ManageBudgetScreen> {
  double totalSpent = 0;
  Map<String, double> spentPerCategory = {};

  double calculateUsage(String category) {
    double spent = spentPerCategory[category] ?? 0;
    double budget = (budgets[category] ?? 0).toDouble();

    if (budget == 0) return 0;

    return spent / budget;
  }

  final List<Map<String, dynamic>> categories = [
    {"key": "food", "title": "Food", "icon": "assets/diet.png"},
    {"key": "travel", "title": "Travel", "icon": "assets/travel-luggage.png"},
    {"key": "shopping", "title": "Shopping", "icon": "assets/shopping-bag.png"},
    {"key": "bills", "title": "Bills", "icon": "assets/bill.png"},
    {"key": "others", "title": "Others", "icon": "assets/delivery-box.png"},
  ];
  Map<String, double> budgets = {};
  double totalBudget = 0;
  bool isLoading = true;
  Future<void> loadBudgetData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final userSnapshot = await userDoc.get();
    final transactionSnapshot = await userDoc.collection('transactions').get();

    Map<String, double> tempBudgets = {};
    Map<String, double> tempSpent = {};

    /// Budgets
    final data = userSnapshot.data();
    if (data != null && data['budgets'] != null) {
      tempBudgets = Map<String, double>.from(
        (data['budgets'] as Map).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      );
    }

    /// Spending
    for (var doc in transactionSnapshot.docs) {
      final transaction = doc.data();

      String category = transaction['category'];
      double amount = (transaction['amount'] as num).toDouble();

      tempSpent[category] = (tempSpent[category] ?? 0) + amount;
    }

    setState(() {
      budgets = tempBudgets;
      spentPerCategory = tempSpent;

      totalBudget = tempBudgets.values.fold(0, (sum, item) => sum + item);
      totalSpent = tempSpent.values.fold(0, (sum, item) => sum + item);

      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadBudgetData();
  }

  @override
  Widget build(BuildContext context) {
    final incomeAsync = ref.watch(monthlyIncomeProvider);

    final income = incomeAsync.maybeWhen(
      data: (value) => value,
      orElse: () => 0.0,
    );
    double screenHeight = MediaQuery.of(context).size.height;
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainNavigation()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        toolbarHeight: 84,
        title: Column(
          children: [
            const Text(
              "Manage Budget",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
            SizedBox(height: 1),
            Text(
              "Your monthly income is ${formatCurrency(income)} per month",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          /// SCROLLABLE AREA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 102,
                    width: 380,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "₹ ${totalSpent.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "spent of",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "₹ ${income.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showAdjustIncomeBottomSheet(context, ref);
                                },
                                child: Icon(Icons.edit, size: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(12),
                            minHeight: 14,
                            value:
                                totalBudget == 0
                                    ? 0
                                    : (totalSpent / totalBudget).clamp(0, 1),
                            backgroundColor: Colors.grey.shade300,
                            color: Color.fromARGB(255, 100, 159, 255),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${((totalBudget == 0 ? 0 : (totalSpent / totalBudget)) * 100).toStringAsFixed(0)}% ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SFProText',
                                      color: Color.fromARGB(255, 100, 159, 255),
                                    ),
                                  ),
                                  Text(
                                    "Spent",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SFProText',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "₹ ${(totalBudget - totalSpent).toStringAsFixed(0)} Remaining",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SFProText',
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Expense Breakdown",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// CATEGORY LIST
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final key = category["key"];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ExpenseAdjustWidget(
                          onTap:
                              () => showAdjustBudgetBottomSheet(
                                context,
                                key,
                                (budgets[key] ?? 0).toDouble(),
                                category["icon"],
                                (spentPerCategory[key] ?? 0).toDouble(),
                              ),
                          title: category["title"],
                          imagePath: category["icon"],
                          budget: (budgets[key] ?? 0).toDouble(),
                          spent: (spentPerCategory[key] ?? 0).toDouble(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// ALERTS
                  const Text(
                    "Alerts",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),

                  const SizedBox(height: 10),

                  AlertsContainer(
                    title: 'Alert on Budget Exceed',
                    subTitle: 'Receive alerts when budget exceed',
                  ),

                  const SizedBox(height: 10),

                  AlertsContainer(
                    title: 'Alert on Category Limit',
                    subTitle: 'Receive alerts when category budget exceed',
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          /// FIXED BUTTON AREA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                ElevatedButtonCust('Adjust Budget', () {
                  Navigator.pop(context);
                }),

                const SizedBox(height: 8),

                const Text(
                  'Simulation only. No data is changes',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showAdjustBudgetBottomSheet(
  BuildContext context,
  String categoryKey,
  double currentBudget,
  String iconPath,
  double spentAmount,
) {
  final TextEditingController budgetController = TextEditingController();
  budgetController.text = currentBudget.toString();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Indicator
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              /// Title
              Text(
                "Adjust ${categoryKey[0].toUpperCase()}${categoryKey.substring(1)} Budget",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 10),

              /// Budget Info Row
              Row(
                children: [
                  Image.asset(iconPath, height: 40, width: 40),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Budget : ₹${currentBudget.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Spent : ₹${spentAmount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 15),

              /// Enter Budget Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter New Budget",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 10),

              /// TextField
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "20,000",
                  prefixText: "₹ ",
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Buttons Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// Save
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        double newBudget =
                            double.tryParse(budgetController.text) ??
                            currentBudget;

                        if (context.mounted) {
                          Navigator.pop(context);
                        }

                        final userDoc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid);

                        final snapshot = await userDoc.get();
                        Map<String, dynamic> budgets =
                            Map<String, dynamic>.from(
                              snapshot.data()?['budgets'] ?? {},
                            );

                        budgets[categoryKey] = newBudget;

                        await userDoc.update({"budgets": budgets});

                        if (context.mounted) {
                          final state =
                              context
                                  .findAncestorStateOfType<
                                    _ManageBudgetScreenState
                                  >();
                          state?.loadBudgetData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 46, 150, 255),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

void showAdjustIncomeBottomSheet(BuildContext context, WidgetRef ref) {
  final incomeAsync = ref.watch(monthlyIncomeProvider);

  final income = incomeAsync.maybeWhen(
    data: (value) => value,
    orElse: () => 0.0,
  );

  final TextEditingController incomeController = TextEditingController(
    text: income == 0 ? "" : income.toString(),
  );
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Indicator
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              const Text(
                "Adjust Monthly Income",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// Enter Income Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter New Income",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 10),

              /// TextField
              TextField(
                controller: incomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // hintText: "$income",
                  prefixText: "₹ ",
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Buttons Row
              Row(
                children: [
                  /// Cancel
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// Save
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        double newIncome =
                            double.tryParse(incomeController.text) ?? income;

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({"monthlyIncome": newIncome});

                        ref.invalidate(monthlyIncomeProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          46,
                          150,
                          255,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
