import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String price;

  const ProductCard({
    super.key,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          /// PRICE ABOVE IMAGE
Padding(
  padding: const EdgeInsets.symmetric(vertical: 4),
  child: Text(
    "Rs $price",
    textScaler: const TextScaler.linear(1.0),
    style: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10, // 👈 now this WILL shrink
      letterSpacing: 0.3,
    ),
  ),
),
          /// IMAGE + ICONS
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Favorite
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.red,
                    ),
                  ),
                ),

                /// Add to cart
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
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
