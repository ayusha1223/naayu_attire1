import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';
import 'package:naayu_attire1/features/admin/domain/usecases/update_order_status.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {

  late UpdateOrderStatusUsecase usecase;
  late MockAdminRepository repository;

  setUp(() {
    repository = MockAdminRepository();
    usecase = UpdateOrderStatusUsecase(repository);
  });

  test("should call updateOrderStatus in repository", () async {

    when(() => repository.updateOrderStatus("1", "shipped"))
        .thenAnswer((_) async {});

    await usecase.call("1", "shipped");

    verify(() => repository.updateOrderStatus(
      "1",
      "shipped",
    )).called(1);

  });

}