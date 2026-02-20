import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naayu_attire1/core/constants/api_constants.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class AdminService {

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenService = TokenService(prefs);

    final token = tokenService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please login again.");
    }

    return token;
  }

  /// 📊 Dashboard
  Future<Map<String, dynamic>> getDashboardStats() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/dashboard"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load dashboard stats");
    }
  }
  Future<List<dynamic>> getMonthlyRevenue() async {
  final token = await _getToken();

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/api/admin/monthly-revenue"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load monthly revenue");
  }
}
  /// 💳 GET ALL PAYMENTS
Future<List<dynamic>> getPayments() async {
  final token = await _getToken();

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/api/admin/payments"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load payments");
  }
}

  /// 👥 Get Users
  Future<List<dynamic>> getUsers() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }
  /// 📦 GET ALL ORDERS
Future<List<dynamic>> getOrders() async {
  final token = await _getToken();

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/api/v1/orders/admin"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load orders");
  }
}

  /// ❌ Delete User
  Future<void> deleteUser(String userId) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users/$userId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete user");
    }
  }

  /// ➕ Create User
  Future<void> createUser(
    String name,
    String email,
    String password,
  ) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create user");
    }
  }

  /// ✏ Update User
  Future<void> updateUser(
    String userId,
    String name,
    String email,
  ) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users/$userId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update user");
    }
  }
}