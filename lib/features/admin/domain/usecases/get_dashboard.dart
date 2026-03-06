import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';

class GetDashboardUsecase {
  final AdminRepository repository;

  GetDashboardUsecase(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getDashboardStats();
  }
}