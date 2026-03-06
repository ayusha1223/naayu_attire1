import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';

class DeleteUserUsecase {
  final AdminRepository repository;

  DeleteUserUsecase(this.repository);

  Future<void> call(String userId) {
    return repository.deleteUser(userId);
  }
}