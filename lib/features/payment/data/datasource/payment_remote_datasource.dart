import 'package:dio/dio.dart';
import '../../domain/entities/payment_entity.dart';

class PaymentRemoteDatasource {

  final Dio dio;

  PaymentRemoteDatasource(this.dio);

  Future<void> processPayment(PaymentEntity payment, String token) async {

    await dio.post(
      "/payments",
      data: {
        "orderId": payment.orderId,
        "paymentMethod": payment.paymentMethod,
        "transactionId": payment.transactionId,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }

}