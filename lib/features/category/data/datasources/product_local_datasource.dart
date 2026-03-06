import 'package:hive/hive.dart';
import '../models/product_model.dart';

class ProductLocalDatasource {

  final Box<ProductModel> box = Hive.box<ProductModel>('products');

  Future<void> cacheProducts(List<ProductModel> products) async {
    await box.clear();
    await box.addAll(products);
  }

  List<ProductModel> getCachedProducts() {
    return box.values.toList();
  }
}