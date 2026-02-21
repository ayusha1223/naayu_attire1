import 'package:flutter/material.dart';
import 'payment_success_screen.dart';

class EsewaOtpScreen extends StatefulWidget {
  final double amount;

  const EsewaOtpScreen({
    super.key,
    required this.amount,
  });

  @override
  State<EsewaOtpScreen> createState() => _EsewaOtpScreenState();
}

class _EsewaOtpScreenState extends State<EsewaOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isOtpValid = false;

  @override
  void initState() {
    super.initState();

    otpController.addListener(() {
      final otp = otpController.text.trim();
      setState(() {
        isOtpValid = otp.length == 6;
      });
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: const Color(0xFF60BB46),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Enter 6-digit OTP sent to your mobile",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isOtpValid ? const Color(0xFF60BB46) : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: isOtpValid
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentSuccessScreen(
                            amount: widget.amount,
                            paymentMethod: 'esewa',
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }
}