import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';

class UpdateOrderStatusUsecase {
  final AdminRepository repository;

  UpdateOrderStatusUsecase(this.repository);

  Future<void> call(
    String orderId,
    String status,
  ) {
    return repository.updateOrderStatus(orderId, status);
  }
}