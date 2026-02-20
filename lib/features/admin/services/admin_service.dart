import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:naayu_attire1/core/constants/api_constants.dart';


class AdminService {
  Future<Map<String, dynamic>> getDashboardStats(String token) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/dashboard"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load dashboard stats");
    }
  }

  Future<List<dynamic>> getUsers(String token) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<void> deleteUser(String token, String userId) async {
    await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/users/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}