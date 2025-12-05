import 'package:flutter/material.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffc4b3ae),
      child: Column(
        children: [
          const SizedBox(height: 100),

          const Text(
            "Discover something new",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Special new arrivals just for you",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 40),

          // Logo instead of product image
          Container(
            height: 180,
            width: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              "assets/images/kurtha_logo.png",
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 40),

          // ⭐ SHOP NOW (CENTERED AREA)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: const Text("Shop now"),
          ),

          // This pushes content upward but leaves space for NEXT button
          const Spacer(),
        ],
      ),
    );
  }
}
