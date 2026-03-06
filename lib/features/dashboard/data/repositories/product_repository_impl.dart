import 'package:naayu_attire1/features/category/data/models/product_model.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {

  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;

  ProductRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
Future<List<ProductModel>> getProducts() async {

    try {

      final remoteProducts = await remote.getProducts();

      await local.cacheProducts(remoteProducts);

      return remoteProducts;

    } catch (e) {

      final cached = local.getCachedProducts();

      return cached;
    }
  }
}