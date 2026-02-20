import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/dashboard/data/flash_products_data.dart';
import 'package:naayu_attire1/features/dashboard/presentation/widgets/premium_product_card.dart';

class BestSellingSection extends StatelessWidget {
  const BestSellingSection({super.key});

  @override
  Widget build(BuildContext context) {

    final List<FlashProduct> bestSellingProducts = [
      FlashProduct(
        imagePath: "assets/images/banners/lehengacholi.png",
        title: "Chaubandi",
        price: 1200,
        oldPrice: 1999,
      ),
      FlashProduct(
        imagePath: "assets/images/banners/wedding.png",
        title: "Cotton",
        price: 999,
        oldPrice: 1299,
      ),
      FlashProduct(
        imagePath: "assets/images/wedding/wedding2.png",
        title: "Royal Bridal",
        price: 1799,
        oldPrice: 2399,
      ),
      FlashProduct(
        imagePath: "assets/images/wedding/wedding1.png",
        title: "Cotton",
        price: 999,
        oldPrice: 1299,
      ),
      FlashProduct(
        imagePath: "assets/images/wedding/wedding12.png",
        title: "Royal Bridal",
        price: 1799,
        oldPrice: 2399,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Best Selling",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bestSellingProducts.length,
              itemBuilder: (context, index) {

                final product = bestSellingProducts[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 170,
                    child: PremiumProductCard(
                      image: product.imagePath,
                      title: product.title,
                      price: product.price,
                      oldPrice: product.oldPrice,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}