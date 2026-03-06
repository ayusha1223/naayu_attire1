import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/presentation/provider/product_provider.dart';

import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_grid.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final String title;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  String selectedColor = "all";
  String selectedSort = "none";

  @override
  Widget build(BuildContext context) {

    final productProvider = context.watch<ProductProvider>();

    List<Product> filteredProducts = productProvider.products
        .where((p) =>
            p.category == widget.category &&
            (selectedColor == "all" || p.color == selectedColor))
        .toList();

    if (selectedSort == "low") {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort == "high") {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredProducts.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              PopupMenuButton<String>(
                child: _filterButton("Sort", Icons.sort),
                onSelected: (value) {
                  setState(() {
                    selectedSort = value;
                  });
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "low", child: Text("Price: Low to High")),
                  PopupMenuItem(value: "high", child: Text("Price: High to Low")),
                ],
              ),

              PopupMenuButton<String>(
                child: _filterButton("Color", Icons.palette_outlined),
                onSelected: (value) {
                  setState(() {
                    selectedColor = value;
                  });
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "all", child: Text("All")),
                  PopupMenuItem(value: "red", child: Text("Red")),
                  PopupMenuItem(value: "blue", child: Text("Blue")),
                  PopupMenuItem(value: "green", child: Text("Green")),
                  PopupMenuItem(value: "black", child: Text("Black")),
                  PopupMenuItem(value: "white", child: Text("White")),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: ProductGrid(
            products: filteredProducts.length > 16
                ? filteredProducts.sublist(0, 16)
                : filteredProducts,
          ),
        ),
      ],
    );
  }

  Widget _filterButton(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}