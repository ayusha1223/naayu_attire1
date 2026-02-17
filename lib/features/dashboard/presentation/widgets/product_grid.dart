import 'package:flutter/material.dart';
import '../../data/flash_products_data.dart';
import 'premium_product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: flashProducts.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.60, // 🔥 More height = no overflow
        ),
        itemBuilder: (context, index) {
          return PremiumProductCard(
            image: flashProducts[index].imagePath,
            title: flashProducts[index].title,
            price: flashProducts[index].price,
            oldPrice: flashProducts[index].oldPrice,
          );
        },
      ),
    );
  }
}
