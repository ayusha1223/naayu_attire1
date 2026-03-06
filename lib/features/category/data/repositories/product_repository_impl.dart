import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {

  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Product>> getProducts() async {

    final models = await remoteDatasource.fetchProducts();

    return models.map((e) => e.toEntity()).toList();

  }
}