import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';
import 'package:naayu_attire1/features/category/presentation/screens/product_detail_screen.dart';
import 'package:naayu_attire1/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:naayu_attire1/features/cart/presentation/screens/cart_screen.dart';

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
    final shop = context.watch<ShopProvider>();

    /// Convert to ProductModel internally
    final product = ProductModel(
      id: title, // using title as id for now
      image: image,
      name: title,
      price: price.toDouble(),
      oldPrice: oldPrice.toDouble(),
      description: "Beautiful traditional outfit",
      rating: 4.5,
      sizes: ["XS", "S", "M", "L", "XL", "XXL"],
      color: "Red",
      isNew: true,
    );

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE CLICK → PRODUCT DETAILS
          Flexible(
            child: Stack(
              children: [

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Center(
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                /// FAVORITE CLICK
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      shop.toggleFavorite(product);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const FavoritesScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        shop.isFavorite(product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: Colors.red,
                      ),
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

          /// PRICE
          Text(
            "Rs.$price",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 6),

          /// DISCOUNT
          Row(
            children: [
              Text(
                "Rs.$oldPrice",
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
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

          /// ADD TO CART CLICK
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
              onPressed: () {
                shop.addToCart(product);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CartScreen(),
                  ),
                );
              },
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