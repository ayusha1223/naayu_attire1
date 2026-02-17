import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [

          /// 🔹 TOP GREY SECTION
          Container(
            height: screenHeight * 0.65,
            width: double.infinity,
            color: const Color(0xFFF2F2F2),
            child: Column(
              children: const [
                SizedBox(height: 100),

                Text(
                  "Update trendy outfit",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Favorite brands and hottest trends",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 BOTTOM MAUVE SECTION
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.45,
              width: double.infinity,
              color: const Color(0xffc4b3ae),
            ),
          ),

          /// 🔥 FLOATING IMAGE (OVERLAPPING)
          Positioned(
            top: screenHeight * 0.30,
            left: 40,
            right: 40,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/onboarding/image21.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
