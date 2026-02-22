import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  const NewPasswordScreen({super.key, required this.email});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isPasswordVisible = false;

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
              const SizedBox(height: 60),

              const Text(
                "Create\nNew Password",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "New Password",
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

              const SizedBox(height: 20),

              TextField(
                controller: confirmController,
                obscureText: !isPasswordVisible,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
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
                          if (passwordController.text !=
                              confirmController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Passwords do not match"),
                              ),
                            );
                            return;
                          }

                          final success =
                              await authVM.resetPassword(
                            widget.email,
                            passwordController.text.trim(),
                          );

                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Password reset successful"),
                              ),
                            );

                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        },
                  child: authVM.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "RESET PASSWORD",
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
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}