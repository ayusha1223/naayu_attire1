import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/features/cart/domain/entities/cart_item.dart';
import 'package:naayu_attire1/features/cart/presentation/provider/cart_provider.dart';

import 'package:naayu_attire1/features/category/domain/entities/product.dart';
import 'package:naayu_attire1/features/category/presentation/screens/product_detail_screen.dart';

import 'package:naayu_attire1/features/favorites/presentation/provider/favorites_provider.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    final favoritesProvider = context.watch<FavoritesProvider>();

    double discount = 0;

    if (product.oldPrice != null && product.oldPrice! > 0) {
      discount =
          ((product.oldPrice! - product.price) / product.oldPrice!) * 100;
    }

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

          /// IMAGE + FAVORITE
          Expanded(
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

                  child: ClipRRect(

                    borderRadius: BorderRadius.circular(12),

                    child: Center(

                      child: product.image.startsWith("http")

                          ? Image.network(
                              product.image,
                              fit: BoxFit.contain,
                              width: double.infinity,

                              loadingBuilder:
                                  (context, child, progress) {

                                if (progress == null) return child;

                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              },

                              errorBuilder:
                                  (context, error, stackTrace) {

                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey,
                                );
                              },
                            )

                          : Image.asset(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                  ),
                ),

                /// FAVORITE BUTTON
                Positioned(

                  top: 0,
                  right: 0,

                  child: GestureDetector(

                    onTap: () {
                      favoritesProvider.toggleFavorite(product);
                    },

                    child: CircleAvatar(

                      radius: 16,
                      backgroundColor: Colors.white,

                      child: Icon(

                        favoritesProvider.isFavorite(product)
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
            product.name,
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
            "Rs.${product.price.toInt()}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          /// OLD PRICE + DISCOUNT
          if (product.oldPrice != null && product.oldPrice! > 0)

            Row(
              children: [

                Text(
                  "Rs.${product.oldPrice!.toInt()}",
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

          /// ADD TO CART
          SizedBox(

            width: double.infinity,
            height: 40,

            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 199, 157, 211),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              onPressed: () {

                final cart = context.read<CartProvider>();

                cart.addToCart(
                  CartItem(
                    id: product.id,
                    name: product.name,
                    price: product.price,
                    image: product.image,
                    quantity: 1,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(
                    content:
                        Text("${product.name} added to cart"),
                    duration: const Duration(seconds: 1),
                    backgroundColor:
                        const Color.fromARGB(255, 47, 46, 47),
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