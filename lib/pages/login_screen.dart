import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginSelected = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,

          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05,
              10,
              screenWidth * 0.05,
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? 20
                  : MediaQuery.of(context).viewInsets.bottom + 4,
            ),
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // ref.read(appFlowProvider.notifier).state =
                  //     AppStatus.ForgetPassword;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3399FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLoginSelected ? "Login" : "Sign Up",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 🔽 Scrollable Content
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.08),

                  const Text(
                    "Welcome!",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Sign up or Login to your Account",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  _buildToggle(),

                  const SizedBox(height: 24),

                  isLoginSelected ? _buildLoginForm() : _buildSignUpForm(),

                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔁 Toggle Widget
  Widget _buildToggle() {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5FF),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          /// Login
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLoginSelected = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                      isLoginSelected
                          ? const Color(0xFF3399FF)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isLoginSelected
                              ? Colors.white
                              : const Color(0xFF3399FF),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Sign Up
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLoginSelected = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                      !isLoginSelected
                          ? const Color(0xFF3399FF)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          !isLoginSelected
                              ? Colors.white
                              : const Color(0xFF3399FF),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Login Form UI
  Widget _buildLoginForm() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Email
        const Text(
          "Email Address",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            hintText: "Enter your Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        /// Password
        const Text(
          "Password",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            hintText: "Enter your Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.001),

        /// Forget Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forget Password ?",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        /// Divider
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Or Login Using"),
            ),
            Expanded(child: Divider()),
          ],
        ),

        SizedBox(height: screenHeight * 0.02),

        /// Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _socialButton("assets/Google.svg"),
            _socialButton("assets/Apple.svg"),
            _socialButton("assets/Facebook.svg"),
          ],
        ),
      ],
    );
  }

  // Sign Up Form UI
  Widget _buildSignUpForm() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name
        const Text(
          "Full Name",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            hintText: "Enter your Full Name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        /// Email
        const Text(
          "Email Address",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            hintText: "Enter your Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        /// Password
        const Text(
          "Password",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            hintText: "Enter your Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.001),

        /// Forget Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forget Password ?",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        /// Divider
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Or Login Using"),
            ),
            Expanded(child: Divider()),
          ],
        ),

        SizedBox(height: screenHeight * 0.03),

        /// Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _socialButton("assets/Google.svg"),
            _socialButton("assets/Apple.svg"),
            _socialButton("assets/Facebook.svg"),
          ],
        ),
      ],
    );
  }

  // Social Button
  Widget _socialButton(String asset) {
    return Container(
      height: 70,
      width: 71,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(asset),
      ),
    );
  }
}
