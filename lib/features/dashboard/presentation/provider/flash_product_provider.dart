import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/data/product_repository.dart';
import 'package:naayu_attire1/features/category/data/casual_data.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';
import 'package:naayu_attire1/features/dashboard/data/flash_products_data.dart';

class FlashProductProvider extends ChangeNotifier {

  List<ProductModel> _allProducts = [];
  List<ProductModel> _searchResults = [];

  List<ProductModel> get allProducts => _allProducts;
  List<ProductModel> get searchResults => _searchResults;

  bool get isSearching => _searchResults.isNotEmpty;

  // ================= LOAD ALL PRODUCTS =================
  Future<void> loadAllProducts() async {

    // 1️⃣ Convert Flash products
    List<ProductModel> flashConverted =
        flashProducts.map((flash) {
      return ProductModel(
        id: flash.title,
        image: flash.imagePath,
        name: flash.title,
        price: flash.price.toDouble(),
        description: "Flash product",
        rating: 4,
        sizes: ["S", "M", "L"],
        color: "Red",
        isNew: true,
        oldPrice: flash.oldPrice?.toDouble(),
        quantity: 1,
        category: "flash",
      );
    }).toList();

    // 2️⃣ Hardcoded products
    List<ProductModel> hardcoded =
        List.from(CasualData.products);

    // 3️⃣ Backend products
    List<ProductModel> backend = [];

    try {
      backend = await ProductRepository.getAllProducts();
    } catch (e) {
      print("Backend error: $e");
    }

    // 4️⃣ Merge ALL
    _allProducts = [
      ...flashConverted,
      ...hardcoded,
      ...backend,
    ];

    notifyListeners();
  }

  // ================= SEARCH =================
Future<void> searchProduct(String query) async {

  if (query.trim().isEmpty) {
    _searchResults = [];
    notifyListeners();
    return;
  }

  try {
    _searchResults =
        await ProductRepository.searchProducts(query);
  } catch (e) {
    print("Search error: $e");
  }

  notifyListeners();
}

  // ================= CLEAR SEARCH =================
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}