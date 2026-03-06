import 'package:flutter/material.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/process_payment_usecase.dart';

class PaymentProvider extends ChangeNotifier {

  final ProcessPaymentUsecase usecase;

  PaymentProvider(this.usecase);

  Future<void> processPayment({
    required String orderId,
    required String method,
  }) async {

    final payment = PaymentEntity(
      orderId: orderId,
      paymentMethod: method,
      transactionId:
          "TXN${DateTime.now().millisecondsSinceEpoch}",
    );

    await usecase(payment);

  }

}