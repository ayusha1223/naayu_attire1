import 'package:flutter/material.dart';
import '../../domain/models/product_model.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';


class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  const ProductGrid({super.key, required this.products});

@override
Widget build(BuildContext context) {
  return Consumer<ShopProvider>(
    builder: (context, shop, _) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.55,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailScreen(product: product),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // 🔥 IMAGE + FAVORITE
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(12),
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),

                        Positioned(
  top: 12,
  right: 12,
  child: InkWell(
    onTap: () {
      shop.toggleFavorite(product);
    },
    child: Icon(
      shop.isFavorite(product)
          ? Icons.favorite
          : Icons.favorite_border,
      color: Colors.red,
      size: 22,
    ),
  ),
),

                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // NAME
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12),
                    child: Text(
                      product.name,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // PRICE
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          "Rs.${product.price.toStringAsFixed(0)}",
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                            width: 6),
                        if (product
                                .oldPrice !=
                            null)
                          Text(
                            "Rs.${product.oldPrice!.toStringAsFixed(0)}",
                            style:
                                const TextStyle(
                              decoration:
                                  TextDecoration
                                      .lineThrough,
                              color:
                                  Colors.grey,
                              fontSize:
                                  12,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🛒 ADD TO CART
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              const Color(
                                  0xFFB28CC8),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        30),
                          ),
                        ),
                        onPressed: () {
                          shop.addToCart(
                              product);

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Added to Cart"),
                              duration:
                                  Duration(
                                      seconds:
                                          1),
                            ),
                          );
                        },
                        child: const Text(
                          "Add to cart",
                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}
