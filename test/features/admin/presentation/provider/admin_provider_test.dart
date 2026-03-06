import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/admin/domain/usecases/get_orders.dart';
import 'package:naayu_attire1/features/admin/presentation/provider/admin_provider.dart';

class MockGetOrdersUsecase extends Mock implements GetOrdersUsecase {}

void main() {

  late AdminProvider provider;
  late MockGetOrdersUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockGetOrdersUsecase();
    provider = AdminProvider(mockUsecase);
  });

  final fakeOrders = [
    {"id": "1", "status": "pending"}
  ];

  test("loadOrders should update orders and set loading false", () async {

    // Arrange
    when(() => mockUsecase())
        .thenAnswer((_) async => fakeOrders);

    // Act
    await provider.loadOrders();

    // Assert
    expect(provider.orders, fakeOrders);
    expect(provider.loading, false);

    verify(() => mockUsecase()).called(1);
    verifyNoMoreInteractions(mockUsecase);

  });

}