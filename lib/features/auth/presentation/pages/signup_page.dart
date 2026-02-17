import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'login_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String? localError;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AuthViewModel>().clearError();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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

                const Text(
                  "Create\nyour account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Enter your name",
                    border: UnderlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email address",
                    border: UnderlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 20),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm password",
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible =
                              !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (localError != null)
                  Text(
                    localError!,
                    style: const TextStyle(color: Colors.red),
                  ),

                if (authVM.errorMessage != null)
                  Text(
                    authVM.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 30),

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
                            setState(() {
                              localError = null;
                            });

                            if (passwordController.text.trim() !=
                                confirmPasswordController.text.trim()) {
                              setState(() {
                                localError = "Passwords do not match";
                              });
                              return;
                            }

                            final success = await authVM.register(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            if (success && mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            }
                          },
                    child: authVM.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Text(
                    "or sign up with",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 UPDATED SOCIAL BUTTONS
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

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Log In",
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

/// 🔥 NEW SOCIAL BUTTON WIDGET
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
