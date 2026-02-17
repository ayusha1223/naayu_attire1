import 'package:flutter/material.dart';

class PremiumProductCard extends StatelessWidget {
  final String image;
  final String title;
  final int price;
  final int oldPrice;

  const PremiumProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    double discount =
        ((oldPrice - price) / oldPrice) * 100;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          /// IMAGE
          Flexible(
            child: Stack(
              children: [

                /// FULL IMAGE VISIBLE
                Center(
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain, // 🔥 FIXED
                  ),
                ),

                /// FAVORITE
                Positioned(
                  top: 0,
                  right: 0,
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
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// TITLE
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 6),

          /// PRICE ROW
          Row(
            children: [
              Text(
                "Rs.$price",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "Rs.$oldPrice",
                style: const TextStyle(
                  decoration:
                      TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "${discount.toStringAsFixed(0)}% off",
                style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// ADD TO CART BUTTON
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 199, 157, 211),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Add to cart",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
