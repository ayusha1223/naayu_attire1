import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';
import 'package:naayu_attire1/features/dashboard/presentation/widgets/product_card.dart';

class BestSellingSection extends StatelessWidget {
  const BestSellingSection({super.key});

  @override
  Widget build(BuildContext context) {

    final List<ProductModel> bestSellingProducts = [
      ProductModel(
        id: "1",
        image: "assets/images/banners/lehengacholi.png",
        name: "Chaubandi",
        price: 1200,
        oldPrice: 1999,
        description: "Beautiful traditional outfit",
        rating: 4.5,
        sizes: ["S", "M", "L"],
        color: "Blue",
        isNew: false,
        category: "casual",
      ),
      ProductModel(
        id: "2",
        image: "assets/images/banners/wedding.png",
        name: "Cotton",
        price: 999,
        oldPrice: 1299,
        description: "Comfortable daily wear",
        rating: 4.3,
        sizes: ["S", "M", "L"],
        color: "Red",
        isNew: false,
        category: "casual",
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

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 170,
                    child: ProductCard(
                      product: bestSellingProducts[index],
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