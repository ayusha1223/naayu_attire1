import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';
import 'package:naayu_attire1/features/admin/domain/usecases/delete_user.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {

  late DeleteUserUsecase usecase;
  late MockAdminRepository repository;

  setUp(() {
    repository = MockAdminRepository();
    usecase = DeleteUserUsecase(repository);
  });

  test("should call deleteUser in repository", () async {

    when(() => repository.deleteUser("1"))
        .thenAnswer((_) async {});

    await usecase.call("1");

    verify(() => repository.deleteUser("1")).called(1);

  });

}