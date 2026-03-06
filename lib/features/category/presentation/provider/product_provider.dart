import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {

  final GetProducts getProducts;

  ProductProvider(this.getProducts);

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {

    try {

      _isLoading = true;
      notifyListeners();

      final box = Hive.box<ProductModel>("productsBox");

      /// FETCH FROM API
      final result = await getProducts();

      _products = result;

      /// SAVE TO HIVE CACHE
      await box.clear();

      final models = result.map((e) => ProductModel(
        id: e.id,
        image: e.image,
        previewImage: e.previewImage,
        name: e.name,
        price: e.price,
        description: e.description,
        rating: e.rating,
        sizes: e.sizes,
        color: e.color,
        isNew: e.isNew,
        oldPrice: e.oldPrice,
        category: e.category,
        quantity: e.quantity,
      )).toList();

      await box.addAll(models);

    } catch (e) {

      debugPrint("API failed, loading cached products");

      final box = Hive.box<ProductModel>("productsBox");

      final cached = box.values.toList();

      _products = cached.map((e) => e.toEntity()).toList();

    } finally {

      _isLoading = false;
      notifyListeners();

    }
  }
}