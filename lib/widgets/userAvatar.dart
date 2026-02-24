import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAvatar extends StatelessWidget {
  final double radius;

  const UserAvatar({super.key, this.radius = 25});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    String? photoUrl = user?.photoURL;

    // Improve Google image quality (optional)
    if (photoUrl != null && photoUrl.contains('s96-c')) {
      photoUrl = photoUrl.replaceAll('s96-c', 's400-c');
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      backgroundImage:
          photoUrl != null ? NetworkImage(photoUrl) : null,
      child: photoUrl == null
          ? const Icon(Icons.person, color: Colors.grey)
          : null,
    );
  }
}