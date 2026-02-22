import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/alerts_container.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:finova_ai/widgets/expense_adjust_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageBudgetScreen extends ConsumerStatefulWidget {
  const ManageBudgetScreen({super.key});

  @override
  ConsumerState<ManageBudgetScreen> createState() => _ManageBudgetScreenState();
}

class _ManageBudgetScreenState extends ConsumerState<ManageBudgetScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(appFlowProvider.notifier).state = AppStatus.authenticated;
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
              "Your current budget limit is ₹16,000 per month",
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 102,
              width: 380,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(31, 112, 112, 112),
                    blurRadius: 10.0,
                    spreadRadius: 12,
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
                          "₹ 9,800",
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
                          "₹ 16,000",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SFProText',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(12),
                      minHeight: 14,
                      value: 0.48,
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
                              "61% ",
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
                          "₹ 6,200 Remaining",
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
            SizedBox(height: 17),
            Text(
              "Expense Breakdown",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProText',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            ExpenseAdjustWidget(
              onTap: () => showAdjustBudgetBottomSheet(context),
              title: 'Food',
              imagePath: 'assets/diet.png',
              budget: '₹ 16,000',
              spent: '5,900',
            ),

            SizedBox(height: 10),
            ExpenseAdjustWidget(
              onTap: () => showAdjustBudgetBottomSheet(context),
              title: 'Travel',
              imagePath: 'assets/travel-luggage.png',
              budget: '₹ 4,000',
              spent: '2,300',
            ),

            SizedBox(height: 10),
            ExpenseAdjustWidget(
              onTap: () => showAdjustBudgetBottomSheet(context),
              title: 'Shopping',
              imagePath: 'assets/shopping-bag.png',
              budget: '₹ 4,000',
              spent: '1,600',
            ),
            SizedBox(height: 17),
            Text(
              "Alerts",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProText',
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            AlertsContainer(
              title: 'Alert on Budget Exceed',
              subTitle: 'Receive alerts when budget exceed',
            ),

            SizedBox(height: screenHeight * 0.01),
            AlertsContainer(
              title: 'Alert on Category Limit',
              subTitle: 'Receive alerts when category budget exceed',
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ElevatedButtonCust('Adjust Budget', () {}),

                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Simulation only. No data is changes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}

void showAdjustBudgetBottomSheet(BuildContext context) {
  final TextEditingController budgetController = TextEditingController();

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
                "Adjust Budget",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 10),

              /// Budget Info Row
              Row(
                children: [
                  Image.asset("assets/diet.png", height: 40, width: 40),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Current Budget : ₹16,000",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Spent : ₹5,900",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      onPressed: () {
                        final newBudget = budgetController.text;

                        // TODO: Save budget logic here

                        Navigator.pop(context);
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
