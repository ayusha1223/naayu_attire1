import 'package:dio/dio.dart';
import 'package:naayu_attire1/features/category/data/models/product_model.dart';

class ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSource(this.dio);

  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get("/products");

    final List data = response.data["data"];

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}