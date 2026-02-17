import 'package:flutter/material.dart';
import '../../data/one_piece_data.dart';
import '../../domain/models/product_model.dart';
import '../widgets/product_grid.dart';

class OnePieceScreen extends StatefulWidget {
  const OnePieceScreen({super.key});

  @override
  State<OnePieceScreen> createState() => _OnePieceScreenState();
}

class _OnePieceScreenState extends State<OnePieceScreen> {

  List<ProductModel> originalProducts = OnePieceData.products;
  List<ProductModel> products = List.from(OnePieceData.products);

  // 🔥 SORT
  void sortLowToHigh() {
    setState(() {
      products.sort((a, b) => a.price.compareTo(b.price));
    });
  }

  void sortHighToLow() {
    setState(() {
      products.sort((a, b) => b.price.compareTo(a.price));
    });
  }

  // 🔥 FILTER BY COLOR
  void filterByColor(String color) {
    setState(() {
      if (color == "all") {
        products = List.from(originalProducts);
      } else {
        products = originalProducts
            .where((product) => product.color == color)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // SORT + FILTER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              PopupMenuButton<String>(
                child: _filterButton("Sort", Icons.sort),
                onSelected: (value) {
                  if (value == "low") {
                    sortLowToHigh();
                  } else {
                    sortHighToLow();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: "low",
                    child: Text("Price: Low to High"),
                  ),
                  PopupMenuItem(
                    value: "high",
                    child: Text("Price: High to Low"),
                  ),
                ],
              ),

              PopupMenuButton<String>(
                child: _filterButton("Color", Icons.palette_outlined),
                onSelected: (value) {
                  filterByColor(value);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "all", child: Text("All")),
                  PopupMenuItem(value: "pink", child: Text("Pink")),
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
          child: ProductGrid(products: products),
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
