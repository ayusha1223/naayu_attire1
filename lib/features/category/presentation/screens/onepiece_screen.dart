import 'package:flutter/material.dart';
import '../../data/one_piece_data.dart';
import '../../data/product_repository.dart';
import '../../domain/models/product_model.dart';
import '../widgets/product_grid.dart';

class OnePieceScreen extends StatefulWidget {
  const OnePieceScreen({super.key});

  @override
  State<OnePieceScreen> createState() => _OnePieceScreenState();
}

class _OnePieceScreenState extends State<OnePieceScreen> {

  late Future<List<ProductModel>> productsFuture;

  List<ProductModel> originalProducts = [];
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    productsFuture = loadProducts();
  }

  Future<List<ProductModel>> loadProducts() async {

    // 1️⃣ Hardcoded
    List<ProductModel> hardcoded =
        List.from(OnePieceData.products);

    // 2️⃣ Backend
    List<ProductModel> backend = [];

    try {
      backend = await ProductRepository.getProducts("onepiece");
    } catch (e) {
      print("Backend error: $e");
    }

    // 3️⃣ Merge
    final merged = [...hardcoded, ...backend];

    originalProducts = merged;
    products = List.from(merged);

    return merged;
  }

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

  // 🔥 FILTER
  void filterByColor(String color) {
    setState(() {
      if (color == "all") {
        products = List.from(originalProducts);
      } else {
        products = originalProducts
            .where((product) =>
                product.color.toLowerCase() == color.toLowerCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: productsFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading products"));
        }

        return Column(
          children: [

            /// SORT + FILTER
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
      },
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