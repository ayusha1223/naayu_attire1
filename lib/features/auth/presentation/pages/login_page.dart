import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/bottom_screens/presentation/screens/home_screen.dart';
import 'signup_page.dart';
import 'package:naayu_attire1/core/services/sensors/fingerprint_service.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 🔹 Controllers (same as old code)
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// Title (UNCHANGED)
                const Text(
                  "Log into\nyour account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),
                const SizedBox(height: 16),

SizedBox(
  width: double.infinity,
  height: 50,
  child: OutlinedButton.icon(
    icon: const Icon(Icons.fingerprint),
    label: const Text("Login with Fingerprint"),
    onPressed: () async {
      final fingerprintService = FingerprintService();
      final isAuthenticated = await fingerprintService.authenticate();

      if (!isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fingerprint authentication failed")),
        );
        return;
      }

      final tokenService =
          Provider.of<TokenService>(context, listen: false);

      final token = tokenService.getToken();

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please login once with email & password"),
          ),
        );
        return;
      }

      // ✅ Token exists → go to Home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    },
  ),
),


                /// Email (NOW CONNECTED)
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email address",
                    border: UnderlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                /// Password (NOW CONNECTED)
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: UnderlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                /// Forgot password (UNCHANGED)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔴 Error message (FROM API)
                if (authVM.errorMessage != null)
                  Text(
                    authVM.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 20),

                /// LOGIN BUTTON (API FLOW)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7c5cff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: authVM.isLoading
                        ? null
                        : () async {
                            final success = await authVM.login(
  email: emailController.text.trim(),
  password: passwordController.text.trim(),
);



                            if (success && mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
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

                const SizedBox(height: 20),

                /// Or login with (UNCHANGED)
                const Center(
                  child: Text(
                    "or log in with",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 20),

                /// Social buttons (UNCHANGED)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _SocialButton(icon: Icons.g_mobiledata),
                    SizedBox(width: 20),
                    _SocialButton(icon: Icons.facebook),
                  ],
                ),

                const SizedBox(height: 40),

                /// Sign up (UNCHANGED)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Social button widget (UNCHANGED)
class _SocialButton extends StatelessWidget {
  final IconData icon;

  const _SocialButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, size: 28),
    );
  }
}
