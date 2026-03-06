import 'package:naayu_attire1/features/payment/data/datasource/payment_remote_datasource.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';


class PaymentRepositoryImpl implements PaymentRepository {

  final PaymentRemoteDatasource datasource;

  PaymentRepositoryImpl(this.datasource);

  @override
  Future<void> processPayment(PaymentEntity payment) {

    return datasource.processPayment(payment, "");

  }

}