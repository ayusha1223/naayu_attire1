import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import '../../domain/models/product_model.dart';
import 'package:naayu_attire1/features/payment/presentation/delivery_details_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  int selectedSizeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final shop = context.watch<ShopProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // 🔥 IMAGE SECTION
            Expanded(
              child: Stack(
                children: [

                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F1EC),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // BACK
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () =>
                            Navigator.pop(context),
                      ),
                    ),
                  ),

                  // FAVORITE
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          shop.isFavorite(product)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          shop.toggleFavorite(product);
                        },
                      ),
                    ),
                  ),

                  // NEW BADGE
                  if (product.isNew)
                    Positioned(
                      top: 16,
                      left: 80,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "NEW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 🔥 DETAILS SECTION
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      // NAME + RATING
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color:
                                    Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(
                                  width: 4),
                              Text(
                                product.rating
                                    .toString(),
                                style:
                                    const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold),
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        product.description,
                        style:
                            const TextStyle(
                                color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      // SIZE
                      const Text(
                        "Select Size",
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: List.generate(
                          product.sizes.length,
                          (index) =>
                              GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSizeIndex =
                                    index;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets
                                      .only(
                                          right: 10),
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                          horizontal:
                                              14,
                                          vertical:
                                              8),
                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),
                                color:
                                    selectedSizeIndex ==
                                            index
                                        ? Colors
                                            .brown
                                        : Colors
                                            .grey
                                            .shade200,
                              ),
                              child: Text(
                                product
                                    .sizes[index],
                                style: TextStyle(
                                  color: selectedSizeIndex ==
                                          index
                                      ? Colors
                                          .white
                                      : Colors
                                          .black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Color : ${product.color}",
                        style:
                            const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16),
                      ),

                      const SizedBox(height: 20),

                      // PRICE
                      Row(
                        children: [
                          Text(
                            "Rs.${product.price.toStringAsFixed(0)}",
                            style:
                                const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                              width: 10),
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
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // 🔥 BUTTONS
                      Row(
                        children: [

                          // ADD TO CART
                          Expanded(
                            child:
                                ElevatedButton(
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    const Color
                                        .fromARGB(
                                            255,
                                            175,
                                            171,
                                            175),
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                            vertical:
                                                14),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              12),
                                ),
                              ),
                              onPressed: () {
                                shop.addToCart(
                                    product);

                                ScaffoldMessenger
                                        .of(context)
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
                              child:
                                  const Text(
                                      "Add to Cart"),
                            ),
                          ),

                          const SizedBox(
                              width: 10),

                          // BUY NOW
                          Expanded(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor:
          const Color.fromARGB(255, 233, 146, 146),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {
      shop.addToCart(product);

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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
