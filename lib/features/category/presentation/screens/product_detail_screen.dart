import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/features/category/domain/entities/product.dart';
import 'package:naayu_attire1/features/category/presentation/provider/product_provider.dart';

import 'package:naayu_attire1/features/cart/domain/entities/cart_item.dart';
import 'package:naayu_attire1/features/cart/presentation/provider/cart_provider.dart';

import 'package:naayu_attire1/features/favorites/presentation/provider/favorites_provider.dart';
import 'package:naayu_attire1/features/payment/presentation/delivery_details_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedSizeIndex = 0;

  @override
  Widget build(BuildContext context) {

    final product = widget.product;

    final favoritesProvider = context.watch<FavoritesProvider>();
    final productProvider = context.watch<ProductProvider>();

    /// Default sizes if backend empty
    final sizes = product.sizes.isNotEmpty
        ? product.sizes
        : ["S", "M", "L", "XL", "XXL"];

    /// Related Products
    final relatedProducts = productProvider.products
        .where((p) => p.id != product.id)
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= IMAGE SECTION =================
              Stack(
                children: [

                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F1EC),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  /// Back button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  /// Favorite button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          favoritesProvider.isFavorite(product)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(product);
                        },
                      ),
                    ),
                  ),

                  /// NEW badge
                  if (product.isNew)
                    Positioned(
                      top: 16,
                      left: 80,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "NEW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              /// ================= PRODUCT DETAILS =================
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Name + Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      product.description,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// Size selector
                    const Text(
                      "Select Size",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      children: List.generate(
                        sizes.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSizeIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: selectedSizeIndex == index
                                  ? Colors.brown
                                  : Colors.grey.shade200,
                            ),
                            child: Text(
                              sizes[index],
                              style: TextStyle(
                                color: selectedSizeIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Color : ${product.color}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    /// Price
                    Row(
                      children: [
                        Text(
                          "Rs.${product.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (product.oldPrice != null)
                          Text(
                            "Rs.${product.oldPrice!.toStringAsFixed(0)}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Color.fromARGB(255, 199, 157, 211),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// ================= BUTTONS =================
                    Row(
                      children: [

                        /// Add to cart
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 199, 157, 211),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                                const SnackBar(
                                  content: Text("Added to Cart"),
                                ),
                              );
                            },
                            child: const Text("Add to Cart"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// Buy now
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 199, 157, 211),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DeliveryScreen(),
                                ),
                              );
                            },
                            child: const Text("Buy Now"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    /// ================= RELATED PRODUCTS =================

                    const Text(
                      "You May Also Like",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: relatedProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {

                        final related = relatedProducts[index];
                        final theme = Theme.of(context);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: related),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [

                                Expanded(
                                  child: Stack(
                                    children: [

                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.network(
                                            related.image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            favoritesProvider.toggleFavorite(related);
                                          },
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                theme.colorScheme.surface,
                                            child: Icon(
                                              favoritesProvider.isFavorite(related)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favoritesProvider.isFavorite(related)
                                                  ? Colors.red
                                                  : theme.iconTheme.color,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    related.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                Text("Rs.${related.price.toStringAsFixed(0)}"),

                                const SizedBox(height: 6),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {

                                        final cart =
                                            context.read<CartProvider>();

                                        cart.addToCart(
                                          CartItem(
                                            id: related.id,
                                            name: related.name,
                                            price: related.price,
                                            image: related.image,
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
                                      child: const Text(
                                        "Add to Cart",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}