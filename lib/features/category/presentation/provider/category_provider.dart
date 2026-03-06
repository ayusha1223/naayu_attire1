import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

class ProductProvider extends ChangeNotifier {

  final GetProducts getProducts;

  ProductProvider(this.getProducts);

  List<Product> products = [];

  bool isLoading = false;

  Future<void> fetchProducts() async {

    isLoading = true;
    notifyListeners();

    products = await getProducts();

    isLoading = false;
    notifyListeners();
  }
}