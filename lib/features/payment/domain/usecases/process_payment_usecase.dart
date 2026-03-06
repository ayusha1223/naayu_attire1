import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class ProcessPaymentUsecase {

  final PaymentRepository repository;

  ProcessPaymentUsecase(this.repository);

  Future<void> call(PaymentEntity payment) async {
    return repository.processPayment(payment);
  }

}