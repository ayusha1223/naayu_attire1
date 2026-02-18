import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "About Us",
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

            buildSection(
              image: "assets/images/about/journey.jpg",
              title: "How We Reached Here",
              text:
                  "Naayu Attire started as a small dream in Kathmandu with a vision to bring elegant and comfortable fashion to every woman. Through dedication, creativity, and trust from our customers, we have grown into a premium fashion brand loved for its authenticity and quality.",
            ),

            const SizedBox(height: 30),

            buildSection(
              image: "assets/images/about/fabric.jpg",
              title: "We Never Compromise in Fabrics",
              text:
                  "Quality is our promise. Every fabric is carefully selected to ensure comfort, durability, and luxury feel. We believe true elegance begins with premium material that feels as beautiful as it looks.",
            ),

            const SizedBox(height: 30),

            buildSection(
              image: "assets/images/about/women.jpg",
              title: "Empowering Women",
              text:
                  "Naayu Attire proudly provides employment opportunities to talented women artisans. By supporting local craftsmanship, we empower women to build independent futures while preserving traditional skills.",
            ),

            const SizedBox(height: 30),

            buildSection(
              image: "assets/images/about/start.jpg",
              title: "When It All Started",
              text:
                  "Founded in 2023, Naayu Attire was built on passion and purpose. What began as a small idea quickly turned into a movement celebrating confidence, culture, and creativity.",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String image,
    required String title,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // IMAGE LEFT
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 16),

          // TEXT RIGHT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),

                const SizedBox(height: 8),

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
