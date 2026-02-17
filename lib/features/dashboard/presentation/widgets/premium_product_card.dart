import 'package:flutter/material.dart';

class PremiumProductCard extends StatefulWidget {
  final String imagePath;
  final int price;

  const PremiumProductCard({
    super.key,
    required this.imagePath,
    required this.price,
  });

  @override
  State<PremiumProductCard> createState() =>
      _PremiumProductCardState();
}

class _PremiumProductCardState
    extends State<PremiumProductCard> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [

          /// IMAGE + FAVORITE
          Expanded(
            child: Stack(
              children: [

                /// IMAGE
                Positioned.fill(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),

                /// FAVORITE ICON (TOP RIGHT)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFav = !isFav;
                      });
                    },
                    child: Icon(
                      isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// PRICE + CART ROW (BELOW IMAGE)
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              /// PRICE TEXT
              Text(
                "₹${widget.price}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// SMALL CART ICON (NO BACKGROUND)
              const Icon(
                Icons.shopping_cart_outlined,
                size: 20,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
