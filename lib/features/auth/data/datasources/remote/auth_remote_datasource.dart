
import 'package:dio/dio.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/api/api_endpoints.dart';
import 'auth_datasource.dart';
import '../../models/auth_remote_model.dart';

class AuthRemoteDatasourceImpl implements IAuthDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl(this.apiClient);

  // ================= SIGN UP =================
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

    print('REGISTER STATUS: ${response.statusCode}');
    print('REGISTER RESPONSE: ${response.data}');

    return response.statusCode == 200 || response.statusCode == 201;
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

    // assuming backend returns { data: {...user} }
    return AuthRemoteModel.fromJson(response.data['data']);
  }
}
