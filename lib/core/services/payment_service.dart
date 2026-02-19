import 'package:dio/dio.dart';

class PaymentService {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.74:3000/api/v1",
    ),
  );

  Future<void> processPayment({
    required String orderId,
    required String paymentMethod,
    required String token,
  }) async {

    await _dio.post(
      "/payments",
      data: {
        "orderId": orderId,
        "paymentMethod": paymentMethod,
        "transactionId": "TXN${DateTime.now().millisecondsSinceEpoch}",
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}
