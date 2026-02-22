import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart';
import 'new_password_screen.dart';


class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String otpCode = "";

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
                "Verify\nCode",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Enter the 6-digit code sent to\n${widget.email}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                onChanged: (value) {
                  otpCode = value.trim();
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 55,
                  fieldWidth: 45,
                  activeColor: const Color(0xff7c5cff),
                  selectedColor: const Color(0xff7c5cff),
                  inactiveColor: Colors.grey,
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
                          if (otpCode.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter valid 6-digit code"),
                              ),
                            );
                            return;
                          }

                          final success = await authVM.verifyOtp(
                            widget.email,
                            otpCode,
                          );

                          if (success && mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NewPasswordScreen(email: widget.email),
                              ),
                            );
                          }
                        },
                  child: authVM.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "VERIFY",
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
            ],
          ),
        ),
      ),
    );
  }
}