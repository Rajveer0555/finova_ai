import 'package:finova_ai/providers/app_flow_providers.dart';
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
            SizedBox(height: 4),
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
      backgroundColor: Colors.white,
      body: Center(child: Text('This is the Manage Budget Screen')),
    );
  }
}
