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
        final imageUrl = user?.image;

        return ClipOval(
          child: SizedBox(
            width: radius * 2,
            height: radius * 2,
            child:
                imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return _AvatarFallback(radius: radius, isLoading: true);
                      },
                      errorBuilder:
                          (_, __, ___) => _AvatarFallback(radius: radius),
                    )
                    : _AvatarFallback(radius: radius),
          ),
        );
      },

      loading: () => _AvatarFallback(radius: radius, isLoading: true),

      error: (e, _) => _AvatarFallback(radius: radius, showError: true),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final double radius;
  final bool isLoading;
  final bool showError;

  const _AvatarFallback({
    required this.radius,
    this.isLoading = false,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      child:
          isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : Icon(
                showError ? Icons.error : Icons.person,
                color: Colors.white,
              ),
    );
  }
}
