import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';
import 'package:naayu_attire1/features/admin/domain/usecases/get_orders.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {

  late GetOrdersUsecase usecase;
  late MockAdminRepository repository;

  setUp(() {
    repository = MockAdminRepository();
    usecase = GetOrdersUsecase(repository);
  });

  final orders = [
    {"id": "1", "status": "pending"}
  ];

  test("should return list of orders", () async {

    when(() => repository.getOrders())
        .thenAnswer((_) async => orders);

    final result = await usecase.call();

    expect(result, orders);

    verify(() => repository.getOrders()).called(1);
    verifyNoMoreInteractions(repository);

  });

}