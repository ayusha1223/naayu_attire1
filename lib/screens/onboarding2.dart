import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffc4b3ae),
      child: Column(
        children: [
          const SizedBox(height: 100),

          const Text(
            "Update trendy outfit",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Favorite brands and hottest trends",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 40),

          // ⭐ UPDATED LOGO (ONLY THIS PART CHANGED)
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink.shade50,
            ),
           child: ClipOval(
              child: Image.asset(
                "assets/images/SAASHI.jpeg",  // <-- your actual image
                fit: BoxFit.cover,
            ),
          ),
          ),

          const SizedBox(height: 40),

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

          const Spacer(),
        ],
      ),
    );
  }
}
