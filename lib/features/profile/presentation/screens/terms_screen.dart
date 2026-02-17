import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: support@naayuattire.com",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Phone: +977 98XXXXXXXX",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Address: Kathmandu, Nepal",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
