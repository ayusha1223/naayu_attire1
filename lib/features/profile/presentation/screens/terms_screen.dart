import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms & Conditions")),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            "1. All products are subject to availability.\n\n"
            "2. Returns are accepted within 7 days of delivery.\n\n"
            "3. Refunds will be processed within 5-7 business days.\n\n"
            "4. User information is kept secure and confidential.\n\n"
            "5. By using this app, you agree to our policies and terms.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
