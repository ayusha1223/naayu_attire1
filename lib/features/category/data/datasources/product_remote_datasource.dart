import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {

  final Dio dio;

  ProductRemoteDatasource(this.dio);

  Future<List<ProductModel>> fetchProducts() async {

    final response = await dio.get("/products");

    final List<dynamic> data = response.data["data"] ?? [];

    return data
        .map((e) => ProductModel.fromJson(e))
        .toList();

  }
}