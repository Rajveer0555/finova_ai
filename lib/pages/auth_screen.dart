import 'package:finova_ai/pages/forget_password.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/providers/auth_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  static const _googleWebClientId =
      '1034108295430-chor39j77pahrpiori38u9efragnppo8.apps.googleusercontent.com';
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _googleWebClientId,
  );

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => isLoading = true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);

      final userDoc = await userRef.get();

      bool profileCompleted = userDoc.data()?['profileCompleted'] ?? false;

      if (!userDoc.exists) {
        await userRef.set({
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'profileCompleted': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        profileCompleted = userDoc.data()?['profileCompleted'] ?? false;
      }

      if (!mounted) return;

      ref.read(appFlowProvider.notifier).state =
          profileCompleted ? AppStatus.authenticated : AppStatus.infoscreen;
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Google Sign-In failed")));
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Google Sign-In failed")));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signup() async {
    try {
      FocusScope.of(context).unfocus();
      setState(() => isLoading = true);

      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'name': name,
            'email': email,
            'profileCompleted': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      ref.read(appFlowProvider.notifier).state = AppStatus.infoscreen;
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Firestore access failed")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Auth error")));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _login() async {
    try {
      FocusScope.of(context).unfocus();
      setState(() => isLoading = true);

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(credential.user!.uid)
              .get();

      final profileCompleted = userDoc.data()?['profileCompleted'] ?? false;

      if (!mounted) return;

      ref.read(appFlowProvider.notifier).state =
          profileCompleted ? AppStatus.authenticated : AppStatus.infoscreen;
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Firestore access failed")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool isLoading = false;
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
            onPressed:
                isLoading
                    ? null
                    : () async {
                      if (!_formKey.currentState!.validate()) return;

                      if (isLoginSelected) {
                        await _login();
                      } else {
                        await _signup();
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3399FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child:
                isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Row(
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
              Form(
                key: _formKey,
                child: isLoginSelected ? _buildLoginForm() : _buildSignUpForm(),
              ),

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
                emailController.clear();
                passwordController.clear();
                nameController.clear();
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
        _inputField("Enter your Email", controller: emailController),
        SizedBox(height: screenHeight * 0.01),

        const Text(
          "Password",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        _inputField(
          "Enter your Password",
          controller: passwordController,
          isPassword: true,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ForgetPassword()),
              );
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
        _socialButton("assets/Google.svg", onTap: _signInWithGoogle),
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
        _inputField("Enter your Full Name", controller: nameController),

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
        _inputField("Enter your Email", controller: emailController),

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
        _inputField(
          "Enter your Password",
          controller: passwordController,
          isPassword: true,
        ),

        SizedBox(height: screenHeight * 0.03),

        const DividerSection(),

        SizedBox(height: screenHeight * 0.02),
        _socialButton("assets/Google.svg", onTap: _signInWithGoogle),
      ],
    );
  }

  Widget _inputField(
    String hint, {
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Field cannot be empty";
        }
        return null;
      },
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

  Widget _socialButton(String asset, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
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
          ),
        ),
      ],
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
