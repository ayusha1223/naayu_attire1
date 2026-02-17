import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Naayu Attire is a premium fashion brand offering elegant and modern outfits for every occasion. "
          "Our goal is to provide high-quality fabrics with stylish designs at affordable prices.\n\n"
          "We believe fashion should be comfortable, beautiful, and accessible to everyone.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
