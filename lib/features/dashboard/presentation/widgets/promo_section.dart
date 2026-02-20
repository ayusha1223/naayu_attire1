import 'package:flutter/material.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 30),

        PromoBox(
          image: "assets/images/splash/promo1.jpeg",
          title: "UPTO 30% OFF",
        ),

        SizedBox(height: 20),

        PromoBox(
          image: "assets/images/splash/promo2.jpeg",
          title: "FLAT 16% OFF",
        ),

        SizedBox(height: 30),
      ],
    );
  }
}

class PromoBox extends StatelessWidget {
  final String image;
  final String title;

  const PromoBox({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// DISCOUNT HEADER ROW
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xffFCE4EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// IMAGE CARD
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
