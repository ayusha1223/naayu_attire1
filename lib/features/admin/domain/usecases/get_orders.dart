import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';

class GetOrdersUsecase {
  final AdminRepository repository;

  GetOrdersUsecase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getOrders();
  }
}