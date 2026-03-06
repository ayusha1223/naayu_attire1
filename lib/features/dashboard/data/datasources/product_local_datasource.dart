import 'package:hive/hive.dart';
import 'package:naayu_attire1/features/category/data/models/product_model.dart';

class ProductLocalDataSource {

  final box = Hive.box("productsBox");

  Future<void> cacheProducts(List<ProductModel> products) async {
    await box.put(
      "products_data",
      products.map((e) => e.toJson()).toList(),
    );
  }

  List<ProductModel> getCachedProducts() {
    final cached = box.get("products_data");

    if (cached == null) return [];

    return (cached as List)
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}