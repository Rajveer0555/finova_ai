import 'package:finova_ai/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserName extends ConsumerWidget {
  final TextStyle? style;

  const UserName({super.key, this.style});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return userProfile.when(
      data: (user) {
        return Text(
          user?.name ?? "User",
          style: style ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        );
      },

      loading: () => const SizedBox(),

      error: (e, _) => const Text("User"),
    );
  }
}