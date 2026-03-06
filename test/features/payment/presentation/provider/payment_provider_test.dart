import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/payment/presentation/provider/payment_provider.dart';
import 'package:naayu_attire1/features/payment/domain/usecases/process_payment_usecase.dart';
import 'package:naayu_attire1/features/payment/domain/entities/payment_entity.dart';

class MockProcessPaymentUsecase extends Mock
    implements ProcessPaymentUsecase {}

class FakePaymentEntity extends Fake implements PaymentEntity {}

void main() {

  late PaymentProvider provider;
  late MockProcessPaymentUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakePaymentEntity());
  });

  setUp(() {
    usecase = MockProcessPaymentUsecase();
    provider = PaymentProvider(usecase);
  });

  test("processPayment should call usecase", () async {

    when(() => usecase(any())).thenAnswer((_) async {});

    await provider.processPayment(
      orderId: "123",
      method: "cod",
    );

    verify(() => usecase(any())).called(1);
  });

}