import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';
import 'package:naayu_attire1/features/category/presentation/screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final shop = context.read<ShopProvider>();

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
                  child: Center(
                    child: product.image.startsWith("http")
                        ? Image.network(
                            product.image,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),

               Positioned(
  top: 0,
  right: 0,
  child: Consumer<ShopProvider>(
    builder: (context, shop, _) {
      return GestureDetector(
        onTap: () {
          shop.toggleFavorite(product);
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
      );
    },
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
  shop.addToCart(product);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("${product.name} added to cart"),
      duration: const Duration(seconds: 1),
      backgroundColor: const Color.fromARGB(255, 47, 46, 47),
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