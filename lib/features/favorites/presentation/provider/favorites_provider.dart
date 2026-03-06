import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/domain/entities/product.dart';

class FavoritesProvider extends ChangeNotifier {

  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }
}