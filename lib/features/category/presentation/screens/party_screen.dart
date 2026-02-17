import 'package:flutter/material.dart';
import '../../data/party_data.dart';
import '../../domain/models/product_model.dart';
import '../widgets/product_grid.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {

  List<ProductModel> originalProducts = PartyData.products;
  List<ProductModel> products = List.from(PartyData.products);

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
                  PopupMenuItem(value: "black", child: Text("Black")),
                  PopupMenuItem(value: "red", child: Text("Red")),
                  PopupMenuItem(value: "gold", child: Text("Gold")),
                  PopupMenuItem(value: "blue", child: Text("Blue")),
                  PopupMenuItem(value: "white", child: Text("White")),
                  PopupMenuItem(value: "yellow", child: Text("Yellow")),
                  PopupMenuItem(value: "purple", child: Text("Purple")),
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
