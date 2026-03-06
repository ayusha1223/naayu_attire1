import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/features/cart/domain/entities/cart_item.dart';
import 'package:naayu_attire1/features/cart/presentation/provider/cart_provider.dart';

import 'package:naayu_attire1/features/favorites/presentation/provider/favorites_provider.dart';

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

      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {

          final favorites = favoritesProvider.favorites;

          /// EMPTY FAVORITES
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites Yet ❤️",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          /// FAVORITES LIST
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {

              final product = favorites[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                elevation: 2,

                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),

                  /// IMAGE
                  leading: product.image.startsWith("http")
                      ? Image.network(
                          product.image,
                          width: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : Image.asset(
                          product.image,
                          width: 60,
                          fit: BoxFit.contain,
                        ),

                  /// NAME
                  title: Text(
                    product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),

                  /// PRICE
                  subtitle: Text(
                    "Rs. ${product.price.toStringAsFixed(0)}",
                  ),

                  /// OPEN PRODUCT
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },

                  /// ACTION BUTTONS
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// ADD TO CART
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black87,
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

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text("Added to Cart"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),

                      /// REMOVE FAVORITE
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(product);
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