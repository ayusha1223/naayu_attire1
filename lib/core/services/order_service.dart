import 'package:dio/dio.dart';

class OrderService {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.74:3000/api/v1",
    ),
  );

  Future<Map<String, dynamic>> createOrder({
    required List items,
    required double totalAmount,
    required String paymentMethod,
    required String token,
  }) async {

    final response = await _dio.post(
      "/orders",
      data: {
        "items": items,
        "totalAmount": totalAmount,
        "paymentMethod": paymentMethod,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  }
}
