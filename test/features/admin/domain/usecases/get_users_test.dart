import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';
import 'package:naayu_attire1/features/admin/domain/usecases/get_users.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {

  late GetUsersUsecase usecase;
  late MockAdminRepository repository;

  setUp(() {
    repository = MockAdminRepository();
    usecase = GetUsersUsecase(repository);
  });

  final users = [
    {"name": "Ayusha", "email": "test@test.com"}
  ];

  test("should return list of users", () async {

    when(() => repository.getUsers())
        .thenAnswer((_) async => users);

    final result = await usecase.call();

    expect(result, users);

    verify(() => repository.getUsers()).called(1);
    verifyNoMoreInteractions(repository);

  });

}