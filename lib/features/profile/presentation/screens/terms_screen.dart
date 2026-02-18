import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            color: Color(0xFFE91E63),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            buildTermCard(
              number: "1",
              title: "Product Availability",
              text:
                  "All products displayed on Naayu Attire are subject to availability. We reserve the right to modify, discontinue, or limit quantities at any time without prior notice.",
            ),

            const SizedBox(height: 20),

            buildTermCard(
              number: "2",
              title: "Returns & Exchanges",
              text:
                  "Returns are accepted within 7 days of delivery, provided items are unused, unwashed, and in original condition with tags intact.",
            ),

            const SizedBox(height: 20),

            buildTermCard(
              number: "3",
              title: "Refund Policy",
              text:
                  "Approved refunds will be processed within 5–7 business days. The amount will be credited to the original payment method used at checkout.",
            ),

            const SizedBox(height: 20),

            buildTermCard(
              number: "4",
              title: "Privacy & Security",
              text:
                  "Customer data is kept secure and confidential. We do not sell or share personal information with third parties without consent.",
            ),

            const SizedBox(height: 20),

            buildTermCard(
              number: "5",
              title: "Acceptance of Terms",
              text:
                  "By accessing and using the Naayu Attire application, you agree to comply with these terms and policies.",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildTermCard({
    required String number,
    required String title,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // NUMBER CIRCLE
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE91E63),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
