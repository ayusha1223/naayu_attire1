import 'package:flutter/material.dart';
import 'payment_success_screen.dart';

class EsewaOtpScreen extends StatelessWidget {
  final double amount;

  const EsewaOtpScreen({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController =
        TextEditingController();

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
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF60BB46),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PaymentSuccessScreen(amount: amount, paymentMethod: 'esewa',),
                  ),
                );
              },
              child: const Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
