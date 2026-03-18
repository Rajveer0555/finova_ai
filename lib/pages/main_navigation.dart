import 'package:finova_ai/pages/analytics.dart';
import 'package:finova_ai/pages/history_screen.dart';
import 'package:finova_ai/pages/home_screen.dart';
import 'package:finova_ai/pages/profileScreens/profile_screen.dart';
import 'package:finova_ai/providers/bottom_nav_provider.dart';
import 'package:finova_ai/widgets/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    final pages = const [
      HomeScreen(),
      Analytics(),
      HistoryScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(index),
          child: pages[index],
        ),
      ),
      bottomNavigationBar: const FinovaBottomNav(),
    );
  }
}
