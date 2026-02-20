import 'package:flutter/material.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/features/category/presentation/screens/product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<ShopProvider>(
        builder: (context, shop, _) {

          if (shop.favorites.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites Yet ❤️",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: shop.favorites.length,
            itemBuilder: (context, index) {

              final product = shop.favorites[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),

                  leading: Image.asset(
                    product.image,
                    width: 60,
                    fit: BoxFit.contain,
                  ),

                  title: Text(
                    product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),

                  subtitle: Text(
                    "Rs. ${product.price.toStringAsFixed(0)}",
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },

                  /// 🔥 TRAILING WITH TWO BUTTONS
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// 🛒 ADD TO CART
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          shop.addToCart(product);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text("Added to Cart"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),

                      /// ❤️ REMOVE FAVORITE
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          shop.toggleFavorite(product);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}