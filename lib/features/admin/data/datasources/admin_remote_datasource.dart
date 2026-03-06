import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naayu_attire1/core/constants/api_constants.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class AdminRemoteDatasource {

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenService = TokenService(prefs);

    final token = await tokenService.getToken(); // ✅ use await (safe)

    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please login again.");
    }

    return token;
  }

  Map<String, String> _headers(String token, {bool jsonType = false}) {
    return {
      "Authorization": "Bearer $token",
      if (jsonType) "Content-Type": "application/json",
    };
  }

  Exception _httpError(http.Response res, String msg) {
    return Exception("$msg | ${res.statusCode} | ${res.body}");
  }

  /// =============================
  /// 📊 Dashboard
  /// =============================
  Future<Map<String, dynamic>> getDashboardStats() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/dashboard"),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw _httpError(response, "Failed to load dashboard stats");
    }
  }

  /// =============================
  /// 📈 Monthly Revenue
  /// =============================
  Future<List<dynamic>> getMonthlyRevenue() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/monthly-revenue"),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw _httpError(response, "Failed to load monthly revenue");
    }
  }

  /// =============================
  /// 💳 GET ALL PAYMENTS
  /// =============================
  Future<List<dynamic>> getPayments() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/payments"),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw _httpError(response, "Failed to load payments");
    }
  }

  /// =============================
  /// 📦 GET ALL ORDERS
  /// =============================
  Future<List<dynamic>> getOrders() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/orders"),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw _httpError(response, "Failed to load orders");
    }
  }

  /// =============================
  /// 🔄 UPDATE ORDER STATUS
  /// =============================
  Future<void> updateOrderStatus(String orderId, String status) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/orders/$orderId/status"),
      headers: _headers(token, jsonType: true),
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode != 200) {
      throw _httpError(response, "Failed to update order status");
    }
  }

  /// =============================
  /// 💸 REFUND ORDER
  /// =============================
  Future<void> refundOrder(String orderId) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/orders/$orderId/refund"),
      headers: _headers(token, jsonType: true),
    );

    if (response.statusCode != 200) {
      throw _httpError(response, "Failed to refund order");
    }
  }

  /// =============================
  /// 👥 Get Users
  /// =============================
  Future<List<dynamic>> getUsers() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users"),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw _httpError(response, "Failed to load users");
    }
  }

  /// =============================
  /// ❌ Delete User
  /// =============================
  Future<void> deleteUser(String userId) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users/$userId"),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw _httpError(response, "Failed to delete user");
    }
  }

  /// =============================
  /// ➕ Create User
  /// =============================
  Future<void> createUser(String name, String email, String password) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users"),
      headers: _headers(token, jsonType: true),
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 201) {
      throw _httpError(response, "Failed to create user");
    }
  }

  /// =============================
  /// ✏ Update User
  /// =============================
  Future<void> updateUser(String userId, String name, String email) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users/$userId"),
      headers: _headers(token, jsonType: true),
      body: jsonEncode({
        "name": name,
        "email": email,
      }),
    );

    if (response.statusCode != 200) {
      throw _httpError(response, "Failed to update user");
    }
  }
}