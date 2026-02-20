import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/storage/token_service.dart';

class AdminProfileService {
  final String baseUrl = "http://192.168.1.74:3000/api/admin";

  /// 🔐 Get token safely
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenService = TokenService(prefs);
    final token = tokenService.getToken();

    print("TOKEN: $token");

    if (token == null || token.isEmpty) {
      throw Exception("Token is null. User not logged in.");
    }

    return token;
  }

  /// 👤 GET PROFILE
  Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();

    final response = await http
        .get(
          Uri.parse("$baseUrl/profile"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        )
        .timeout(const Duration(seconds: 5));

    print("PROFILE STATUS: ${response.statusCode}");
    print("PROFILE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Profile error ${response.statusCode}: ${response.body}");
    }
  }

  /// 📊 GET DASHBOARD STATS
  Future<Map<String, dynamic>> getDashboardStats() async {
    final token = await _getToken();

    final response = await http
        .get(
          Uri.parse("$baseUrl/dashboard"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        )
        .timeout(const Duration(seconds: 5));

    print("DASHBOARD STATUS: ${response.statusCode}");
    print("DASHBOARD BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Dashboard error ${response.statusCode}: ${response.body}");
    }
  }

  /// ✏️ UPDATE PROFILE
  Future<void> updateProfile(String name, String email) async {
    final token = await _getToken();

    final response = await http
        .put(
          Uri.parse("$baseUrl/profile"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "fullName": name,
            "email": email,
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception(
          "Update failed ${response.statusCode}: ${response.body}");
    }
  }

  /// 🔑 CHANGE PASSWORD
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final token = await _getToken();

    final response = await http
        .put(
          Uri.parse("$baseUrl/change-password"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "currentPassword": currentPassword,
            "newPassword": newPassword,
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception(
          "Password change failed ${response.statusCode}: ${response.body}");
    }
  }
}