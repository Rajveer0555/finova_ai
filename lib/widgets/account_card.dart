import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountCard extends ConsumerStatefulWidget {
  const AccountCard({super.key});

  @override
  ConsumerState<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends ConsumerState<AccountCard> {
  bool isSwitched2 = true;
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
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          InkWell(
            onTap: () {
              ref.read(appFlowProvider.notifier).state = AppStatus.userprofile;
            },
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.08),
                Icon(Icons.person_2_rounded, size: 28),
                SizedBox(width: screenWidth * 0.08),
                RichText(
                  text: TextSpan(
                    text: 'User Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Divider(),
          ),
          SizedBox(height: screenHeight * 0.01),
          InkWell(
            onTap: () {
              showChangePasswordBottomSheet(context);
            },
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.08),
                Icon(Icons.lock_outline, size: 28),
                SizedBox(width: screenWidth * 0.08),
                RichText(
                  text: TextSpan(
                    text: 'Change Passoword',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Divider(),
          ),
          Row(
            children: [
              SizedBox(width: screenWidth * 0.08),
              Icon(Icons.notifications_rounded, size: 28),
              SizedBox(width: screenWidth * 0.08),
              RichText(
                text: TextSpan(
                  text: 'Push Notification',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SFProText',
                  ),
                ),
              ),
              Spacer(),
              Transform.scale(
                scale: 0.9,
                child: CupertinoSwitch(
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: const Color.fromARGB(255, 27, 255, 87),
                  value: isSwitched2,
                  onChanged: (value) {
                    setState(() {
                      isSwitched2 = value;
                    });
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.06),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Divider(),
          ),
          SizedBox(height: screenHeight * 0.01),
          InkWell(
            onTap: () {
              ref.read(appFlowProvider.notifier).state = AppStatus.manage_budget;
            },
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.09),
                Image(
                  image: AssetImage('assets/pie-chart.png'),
                  height: 24,
                  width: 24,
                ),
                SizedBox(width: screenWidth * 0.08),
                RichText(
                  text: TextSpan(
                    text: 'Manage Budget',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}

void showChangePasswordBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ChangePasswordBottomSheet(),
  );
}

class ChangePasswordBottomSheet extends StatelessWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Change Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            _inputField('Create New Password'),

            const SizedBox(height: 14),

            // Confirm Password
            _inputField('Confirm New Password'),

            const SizedBox(height: 22),

            // Save Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ElevatedButtonCust('Save', () {})],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _inputField(String hintText) {
  return SizedBox(
    width: 360,
    child: TextField(
      // obscureText: isPassword,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    ),
  );
}
