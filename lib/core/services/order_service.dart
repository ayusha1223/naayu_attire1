import 'package:dio/dio.dart';

class OrderService {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.74:3000/api/v1",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// ==============================
  /// 🛒 CREATE ORDER
  /// ==============================
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

  /// ==============================
  /// 📦 GET ALL ORDERS (FOR LOGGED USER)
  /// ==============================
  Future<List<dynamic>> getOrders(String token) async {

    final response = await _dio.get(
      "/orders",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    /// If backend returns:
    /// { orders: [...] }
    if (response.data["orders"] != null) {
      return response.data["orders"];
    }

    /// If backend directly returns array
    if (response.data is List) {
      return response.data;
    }

    return [];
  }
}