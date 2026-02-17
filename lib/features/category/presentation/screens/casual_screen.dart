import 'package:flutter/material.dart';
import '../../data/casual_data.dart';
import '../../domain/models/product_model.dart';
import '../widgets/product_grid.dart';

class CasualScreen extends StatefulWidget {
  const CasualScreen({super.key});

  @override
  State<CasualScreen> createState() => _CasualScreenState();
}

class _CasualScreenState extends State<CasualScreen> {

  late List<ProductModel> products;
  String selectedColor = "all";

  @override
  void initState() {
    super.initState();
    products = List.from(CasualData.products);
  }

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

  void filterByColor(String color) {
    setState(() {
      selectedColor = color;

      if (color == "all") {
        products = List.from(CasualData.products);
      } else {
        products = CasualData.products
            .where((product) => product.color == color)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // 🔥 SORT + FILTER BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // SORT
              PopupMenuButton<String>(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.sort, size: 18),
                      SizedBox(width: 6),
                      Text("Sort"),
                    ],
                  ),
                ),
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

              // COLOR FILTER
              PopupMenuButton<String>(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.color_lens_outlined, size: 18),
                      SizedBox(width: 6),
                      Text("Color"),
                    ],
                  ),
                ),
                onSelected: (value) {
                  filterByColor(value);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: "all",
                    child: Text("All"),
                  ),
                  PopupMenuItem(
                    value: "white",
                    child: Text("White"),
                  ),
                  PopupMenuItem(
                    value: "blue",
                    child: Text("Blue"),
                  ),
                  PopupMenuItem(
                    value: "pink",
                    child: Text("Pink"),
                  ),
                  PopupMenuItem(
                    value: "yellow",
                    child: Text("Yellow"),
                  ),
                  PopupMenuItem(
                    value: "orange",
                    child: Text("Orange"),
                  ),
                  PopupMenuItem(
                    value: "brown",
                    child: Text("Brown"),
                  ),
                  PopupMenuItem(
                    value: "green",
                    child: Text("Green"),
                  ),
                  PopupMenuItem(
                    value: "red",
                    child: Text("Red"),
                  ),
                ],
              ),
            ],
          ),
        ),

        // GRID
        Expanded(
          child: ProductGrid(
            products: products,
          ),
        ),
      ],
    );
  }
}
