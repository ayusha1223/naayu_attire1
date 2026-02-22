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

  final relatedProducts = shop.allProducts
      .where((p) => p.id != product.id)
      .take(4)
      .toList();

  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(   // 🔥 FIX 1: whole screen scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= IMAGE SECTION =================
            Stack(
              children: [

                Container(
                  width: double.infinity,
                  color: const Color(0xFFF5F1EC),
                  child: AspectRatio(   // 🔥 FIX 2: remove height conflict
                    aspectRatio: 3 / 4,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.contain,
                    ),
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
                      onPressed: () => Navigator.pop(context),
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

            // ================= DETAILS SECTION =================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // NAME + RATING
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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

                  // SIZE
                  const Text(
                    "Select Size",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  Wrap(   // 🔥 FIX 3: prevents overflow
                    spacing: 10,
                    children: List.generate(
                      product.sizes.length,
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
                            borderRadius:
                                BorderRadius.circular(8),
                            color: selectedSizeIndex == index
                                ? Colors.brown
                                : Colors.grey.shade200,
                          ),
                          child: Text(
                            product.sizes[index],
                            style: TextStyle(
                              color:
                                  selectedSizeIndex == index
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  // PRICE
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
                            decoration:
                                TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 150, 134, 187),
                              foregroundColor: Color.fromARGB(255, 246, 246, 247),
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 14),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                            ),
                          ),
                          onPressed: () {
                            shop.addToCart(product);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Added to Cart"),
                                duration:
                                    Duration(seconds: 1),
                              ),
                            );
                          },
                          child:
                              const Text("Add to Cart"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(
                                    255, 233, 146, 146),
                                    foregroundColor: Color.fromARGB(255, 246, 246, 247),
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 14),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                            ),
                          ),
                          onPressed: () {
                            shop.addToCart(product);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DeliveryScreen(),
                              ),
                            );
                          },
                          child:
                              const Text("Buy Now"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

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
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: relatedProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio:
                          0.65,  // 🔥 FIX 4: overflow solved
                    ),
                    itemBuilder: (context, index) {
                      final related =
                          relatedProducts[index];

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductDetailScreen(
                  product: related),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  // 🔥 PRODUCT IMAGE
                  Positioned.fill(
                    child: Image.asset(
                      related.previewImage ?? related.image,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ❤️ FAVORITE ICON
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        shop.toggleFavorite(related);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          shop.isFavorite(related)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  // 🛒 ADD TO CART ICON
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        shop.addToCart(related);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to Cart"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              related.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Rs.${related.price.toStringAsFixed(0)}",
              style: const TextStyle(color: Colors.black54),
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