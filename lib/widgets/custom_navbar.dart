import 'package:finova_ai/pages/add_screen.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/providers/bottom_nav_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinovaBottomNav extends ConsumerWidget {
  const FinovaBottomNav({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white, // ✅ solid white
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.home, 0, currentIndex, ref),
                _navItem(CupertinoIcons.chart_bar_square, 1, currentIndex, ref),
                const SizedBox(width: 60), // space for +
                _navItem(CupertinoIcons.doc_plaintext, 2, currentIndex, ref),
                _navItem(Icons.person, 3, currentIndex, ref),
              ],
            ),
          ),

          // + Button
          Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTransactionScreen()),
                );
              },
              child: CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFF4A90FF),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index, int currentIndex, WidgetRef ref) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () {
        ref.read(bottomNavIndexProvider.notifier).state = index;
      },
      child: Icon(icon, size: 24, color: isActive ? Colors.black : Colors.grey),
    );
  }
}
