import 'package:finova_ai/pages/auth_screen.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/user_avatar.dart';
import 'package:finova_ai/widgets/user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilerHeader extends ConsumerStatefulWidget {
  const ProfilerHeader({super.key});

  @override
  ConsumerState<ProfilerHeader> createState() => _ProfilerHeaderState();
}

class _ProfilerHeaderState extends ConsumerState<ProfilerHeader> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 0.5, blurRadius: 0.5),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      width: screenWidth * 0.9,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.022,
            ),
            child: UserAvatar(radius: 28),
          ),
          SizedBox(width: screenWidth * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Welcome',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SFProText',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              UserName(
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () async {
              final GoogleSignIn googleSignIn = GoogleSignIn();

              await googleSignIn.disconnect();
              await googleSignIn.signOut();
              await FirebaseAuth.instance.signOut();

              ref.read(appFlowProvider.notifier).state =
                  AppStatus.unauthenticated;

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout_rounded),
            iconSize: 24,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
