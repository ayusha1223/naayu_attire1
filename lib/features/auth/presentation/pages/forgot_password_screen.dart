import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart';
import 'verify_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff8f1ef),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 60),

              const Text(
                "Forgot\nPassword?",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Enter your email address and we’ll\nsend you a reset token.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email address",
                  border: UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7c5cff),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: authVM.isLoading
                      ? null
                      : () async {
                          final success =
                              await authVM.forgotPassword(
                            emailController.text.trim(),
                          );

                          if (success && mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    VerifyOtpScreen(email: emailController.text.trim()),
                              ),
                            );
                          }
                        },
                  child: authVM.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "SEND RESET TOKEN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              if (authVM.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    authVM.errorMessage!,
                    style:
                        const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}