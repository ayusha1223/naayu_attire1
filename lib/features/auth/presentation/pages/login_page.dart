import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/navigation/main_navigation.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/admin/presentation/pages/admin_main_navigation.dart';
import 'signup_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  final LocalAuthentication _auth = LocalAuthentication();
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _startShakeDetection();
  }

  /// ===============================
  /// FINGERPRINT AUTHENTICATION
  /// ===============================
  Future<void> _authenticateWithFingerprint() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometric not available")),
        );
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: "Scan your fingerprint to login",
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fingerprint Login Successful")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ===============================
  /// SHAKE DETECTION
  /// ===============================
  void _startShakeDetection() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      double threshold = 18.0;

      if (event.x.abs() > threshold ||
          event.y.abs() > threshold ||
          event.z.abs() > threshold) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠ Device shaken! Please hold steady."),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff8f1ef),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 50),

              const Text(
                "Log into\nyour account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              /// EMAIL
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email address",
                  border: UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ForgotPasswordScreen(),
    ),
  );
},
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              if (authVM.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    authVM.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7c5cff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: authVM.isLoading
                      ? null
                      : () async {
                          final success = await authVM.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (!mounted) return;

                          if (success) {
                            if (authVM.role == "admin") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AdminMainNavigation(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const MainNavigation(),
                                ),
                              );
                            }
                          }
                        },
                  child: authVM.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "LOG IN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              /// FINGERPRINT BUTTON
              Center(
  child: Column(
    children: [
      Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            print("Fingerprint tapped"); // debug
            _authenticateWithFingerprint();
          },
          child: Container(
            height: 65,
            width: 65,
            alignment: Alignment.center,
            child: const Icon(
              Icons.fingerprint,
              color: Color(0xff7c5cff),
              size: 30,
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        "Login with fingerprint",
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    ],
  ),
),

              const SizedBox(height: 30),

              /// OR DIVIDER
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or sign in with",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),

              const SizedBox(height: 25),

              /// SOCIAL BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SocialButton(
                    imagePath: "assets/images/auth/google.png",
                  ),
                  SizedBox(width: 20),
                  SocialButton(
                    imagePath: "assets/images/auth/facebook.png",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// SIGN UP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String imagePath;

  const SocialButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(imagePath),
      ),
    );
  }
}