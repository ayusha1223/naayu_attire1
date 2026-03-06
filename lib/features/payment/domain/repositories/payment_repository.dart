import '../entities/payment_entity.dart';

abstract class PaymentRepository {

  Future<void> processPayment(PaymentEntity payment);

}