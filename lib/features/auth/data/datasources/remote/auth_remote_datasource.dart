import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/api/api_endpoints.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_datasourse.dart';
import 'package:naayu_attire1/features/auth/data/models/auth_remote_model.dart';



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
    final response = await apiClient.dio.post(
      ApiEndpoints.studentRegister,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    // Accept both success codes
    return response.statusCode == 200 || response.statusCode == 201;
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

    return AuthRemoteModel.fromJson(response.data);
  }
}
