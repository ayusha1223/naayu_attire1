import 'package:dio/dio.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/api/api_endpoints.dart';
import 'auth_datasource.dart';
import '../../models/auth_remote_model.dart';

class AuthRemoteDatasourceImpl implements IAuthDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl(this.apiClient);

  // ================= REGISTER =================
  @override
  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.studentRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } on DioException catch (e) {
      print('REGISTER ERROR: ${e.response?.data}');
      return false;
    }
  }

  // ================= LOGIN =================
  @override
  Future<AuthRemoteModel> login(
    String email,
    String password,
  ) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.studentLogin,
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthRemoteModel.fromJson(response.data['data']);
  }

  // ================= FORGOT PASSWORD =================
  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: {
          'email': email,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('FORGOT ERROR: ${e.response?.data}');
      return false;
    }
  }

  // ================= VERIFY OTP =================
  @override
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'email': email,
          'otp': otp,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('VERIFY OTP ERROR: ${e.response?.data}');
      return false;
    }
  }

  // ================= RESET PASSWORD =================
  @override
  Future<bool> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'newPassword': newPassword,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('RESET PASSWORD ERROR: ${e.response?.data}');
      return false;
    }
  }
}