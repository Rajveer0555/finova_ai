import 'package:finova_ai/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  final double radius;

  const UserAvatar({super.key, this.radius = 25});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userProfile = ref.watch(userProfileProvider);

    return userProfile.when(
      data: (user) {

        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: (user?.image != null && user!.image!.isNotEmpty)
              ? NetworkImage(user.image!)
              : null,
          child: (user?.image == null || user!.image!.isEmpty)
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        );
      },

      loading: () => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),

      error: (e, _) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.error),
      ),
    );
  }
}