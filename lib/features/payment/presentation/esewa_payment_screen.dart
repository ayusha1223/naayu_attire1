import 'package:flutter/material.dart';

class EsewaPaymentScreen extends StatelessWidget {
  const EsewaPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final esewaIdController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("eSewa Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: esewaIdController,
              decoration: const InputDecoration(
                labelText: "eSewa ID",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Payment Successful!"),
                  ),
                );
              },
              child: const Text("Pay via eSewa"),
            ),
          ],
        ),
      ),
    );
  }
}
