import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';
import 'package:naayu_attire1/features/admin/domain/usecases/create_user.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {

  late CreateUserUsecase usecase;
  late MockAdminRepository repository;

  setUp(() {
    repository = MockAdminRepository();
    usecase = CreateUserUsecase(repository);
  });

  test("should call createUser in repository", () async {

    when(() => repository.createUser("Ayusha", "test@test.com", "123456"))
        .thenAnswer((_) async {});

    await usecase.call("Ayusha", "test@test.com", "123456");

    verify(() => repository.createUser(
      "Ayusha",
      "test@test.com",
      "123456",
    )).called(1);

  });

}