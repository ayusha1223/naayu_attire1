import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/dashboard/data/flash_products_data.dart';

class FlashProductProvider extends ChangeNotifier {
  List<FlashProduct> allProducts = flashProducts;
  List<FlashProduct> filteredProducts = flashProducts;

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts = allProducts;
    } else {
      filteredProducts = allProducts.where((product) {
        return product.title
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}