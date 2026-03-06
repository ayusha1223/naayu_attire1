import 'package:naayu_attire1/features/category/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
}