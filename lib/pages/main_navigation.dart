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
      body: pages[index],
      bottomNavigationBar: const FinovaBottomNav(),
    );
  }
}
