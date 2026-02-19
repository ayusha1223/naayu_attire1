import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';

class ShopProvider extends ChangeNotifier {

  final List<ProductModel> _cart = [];
  final List<ProductModel> _favorites = [];

  List<ProductModel> get cart => _cart;
  List<ProductModel> get favorites => _favorites;

  void addToCart(ProductModel product) {
    if (!_cart.contains(product)) {
      _cart.add(product);
      notifyListeners();
    }
  }

  void removeFromCart(ProductModel product) {
    _cart.remove(product);
    notifyListeners();
  }

  void toggleFavorite(ProductModel product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(ProductModel product) {
    return _favorites.contains(product);
  }
}
