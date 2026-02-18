import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  @override
  Widget build(BuildContext context) {
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
        toolbarHeight: 64,
        title: const Text(
          "FAQ's",
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              ExpandableFaqCard(
                title: "What is Finova AI ?",
                content:
                    "Finova AI is an intelligent financial management app designed to help you take full control of your money. It allows you to track expenses, manage budgets, monitor cash flow, and gain AI-powered insights into your spending habits.\n\nBy combining advanced analytics with a simple, user-friendly interface, Finova AI helps you make smarter financial decisions and achieve your long-term financial goals with confidence.",
              ),
              ExpandableFaqCard(
                title: "How does expense tracking work ?",
                content:
                    "Finova AI makes expense tracking simple and automatic. You can manually add transactions or connect your financial accounts for real-time updates.\n\nThe app automatically categorizes your expenses, identifies spending patterns, and provides visual reports so you can clearly see where your money is going. Smart AI insights help you detect overspending and suggest improvements.",
              ),
              ExpandableFaqCard(
                title: "Is my data secure ?",
                content:
                    "Yes, your data security is our top priority. Finova AI uses bank-level encryption and secure cloud infrastructure to protect your financial information.\n \nAll sensitive data is encrypted both in transit and at rest. We follow strict security protocols to ensure your personal and financial details remain private and protected at all times.",
              ),
              ExpandableFaqCard(
                title: "What benefits do i get with pro",
                content:
                    "Finova AI Pro unlocks advanced features to enhance your financial management experience. With Pro, you get detailed analytics, predictive AI insights, unlimited transaction history, and advanced budgeting tools.\n \nYou also gain access to premium reports, export options, and priority customer support to help you manage your finances more effectively.",
              ),
              ExpandableFaqCard(
                title: "How does billing work ?",
                content:
                    "Finova AI offers flexible subscription plans billed monthly or annually. Your subscription is managed securely through the app store, and you can upgrade, downgrade, or cancel anytime from your account settings.\n \nThere are no hidden charges, and you will always be notified before any renewal.",
              ),
              ExpandableFaqCard(
                title: "How can i contact support ?",
                content:
                    "f you need assistance, our support team is ready to help. You can reach us directly through the Help & Support section inside the app or contact us via email.\n \nWe aim to respond quickly and ensure you get the guidance you need to make the most of Finova AI.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
