import 'package:naayu_attire1/features/category/data/models/product_model.dart';
import '../repositories/product_repository.dart';

class GetProducts {

  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<ProductModel>> call() async {
    return await repository.getProducts();
  }
}