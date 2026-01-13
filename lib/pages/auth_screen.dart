import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/providers/auth_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoginSelected = ref.watch(authModeProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          10,
          screenWidth * 0.05,
          MediaQuery.of(context).viewInsets.bottom == 0
              ? 80
              : MediaQuery.of(context).viewInsets.bottom + 4,
        ),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              ref.read(appFlowProvider.notifier).state =
                  AppStatus.loading_state;
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
                RichText(
                  text: TextSpan(
                    text: isLoginSelected ? "Login" : "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.08),

              RichText(
                text: TextSpan(
                  text: "Welcome!",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "Sign up or Login to your Account",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
  }

  Widget _buildToggle() {
    final isLoginSelected = ref.watch(authModeProvider);

    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5FF),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          // Login
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(authModeProvider.notifier).state = true;
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
                  child: RichText(
                    text: TextSpan(
                      text: "Login",
                      style: TextStyle(
                        fontFamily: 'SFProText',
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
          ),

          // Sign Up
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(authModeProvider.notifier).state = false;
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
                  child: RichText(
                    text: TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        fontFamily: 'SFProText',
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
        RichText(
          text: TextSpan(
            text: "Email Address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProText',
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        _inputField("Enter your Email"),

        SizedBox(height: screenHeight * 0.01),

        const Text(
          "Password",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        _inputField("Enter your Password", isPassword: true),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ref.read(appFlowProvider.notifier).state =
                  AppStatus.ForgetPassword;
            },
            child: RichText(
              text: TextSpan(
                text: "Forget Password ?",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.002),
        const DividerSection(),
        SizedBox(height: screenHeight * 0.02),
        _socialButtons(),
      ],
    );
  }

  // Sign Up Form UI
  Widget _buildSignUpForm() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Full Name",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProText',
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        _inputField("Enter your Full Name"),

        SizedBox(height: screenHeight * 0.01),

        RichText(
          text: TextSpan(
            text: "Email Address",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProText',
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        _inputField("Enter your Email"),

        SizedBox(height: screenHeight * 0.01),

        RichText(
          text: TextSpan(
            text: "Password",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProText',
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        _inputField("Enter your Password", isPassword: true),

        SizedBox(height: screenHeight * 0.03),

        const DividerSection(),

        SizedBox(height: screenHeight * 0.02),
        _socialButtons(),
      ],
    );
  }

  Widget _inputField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _socialButtons() {
    return Column(
      children: [
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

class DividerSection extends StatelessWidget {
  const DividerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: RichText(
            text: TextSpan(
              text: "Or Login Using",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
