import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/domain/entities/product.dart';

class FlashProductProvider extends ChangeNotifier {

  List<Product> _searchResults = [];
  List<Product> get searchResults => _searchResults;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  void searchProducts(List<Product> products, String query) {

    if (query.trim().isEmpty) {
      _isSearching = false;
      _searchResults = [];
    } else {

      _isSearching = true;

      _searchResults = products
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }
}