import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/auth_remote_model.dart';
import 'auth_datasource.dart';

class AuthRemoteDatasourceImpl implements IAuthDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl(this.apiClient);

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

    return response.statusCode == 201;
  }

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
