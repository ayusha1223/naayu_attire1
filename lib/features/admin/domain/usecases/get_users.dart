import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';

class GetUsersUsecase {
  final AdminRepository repository;

  GetUsersUsecase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getUsers();
  }
}