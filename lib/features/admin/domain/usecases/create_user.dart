import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';

class CreateUserUsecase {
  final AdminRepository repository;

  CreateUserUsecase(this.repository);

  Future<void> call(
    String name,
    String email,
    String password,
  ) {
    return repository.createUser(name, email, password);
  }
}