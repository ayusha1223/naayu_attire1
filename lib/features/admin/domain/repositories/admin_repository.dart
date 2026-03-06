abstract class AdminRepository {

  Future<Map<String,dynamic>> getDashboardStats();

  Future<List<dynamic>> getOrders();

  Future<void> updateOrderStatus(String orderId,String status);

  Future<List<dynamic>> getUsers();

  Future<void> deleteUser(String userId);

  Future<void> createUser(String name,String email,String password);

}