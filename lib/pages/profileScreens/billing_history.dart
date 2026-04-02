import 'package:finova_ai/widgets/billing_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillingHistoryScreen extends ConsumerStatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  ConsumerState<BillingHistoryScreen> createState() =>
      _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends ConsumerState<BillingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        toolbarHeight: 64,
        title: const Text(
          "Billing History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFProText',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              SizedBox(height: 20),
              BillingHistoryCard(
                imagePath: 'assets/credit-card.png',
                date: "Dec 31,2025",
                payMethod: "Credit Card",
              ),
              SizedBox(height: 14),
              BillingHistoryCard(
                imagePath: 'assets/ewallet.png',
                date: "Nov 30,2025",
                payMethod: "Wallet",
              ),
              SizedBox(height: 14),
              BillingHistoryCard(
                imagePath: 'assets/contactless.png',
                date: "Oct 31,2025",
                payMethod: "Debit Card",
              ),
              SizedBox(height: 14),
              BillingHistoryCard(
                imagePath: 'assets/credit-card.png',
                date: "Sep 30,2025",
                payMethod: "Credit Card",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
