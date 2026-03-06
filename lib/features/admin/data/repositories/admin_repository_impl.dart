import 'package:naayu_attire1/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:naayu_attire1/features/admin/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {

  final AdminRemoteDatasource datasource;

  AdminRepositoryImpl(this.datasource);

  @override
  Future<List<dynamic>> getOrders() {
    return datasource.getOrders();
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) {
    return datasource.updateOrderStatus(orderId, status);
  }

  @override
  Future<Map<String, dynamic>> getDashboardStats() {
    return datasource.getDashboardStats();
  }

  @override
  Future<List<dynamic>> getUsers() {
    return datasource.getUsers();
  }

  @override
  Future<void> deleteUser(String userId) {
    return datasource.deleteUser(userId);
  }

  @override
  Future<void> createUser(String name, String email, String password) {
    return datasource.createUser(name, email, password);
  }
}