import 'package:dio/dio.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class ProfileService {
  final Dio dio;
  final TokenService tokenService;

  ProfileService(this.dio, this.tokenService);

  Future<void> updateProfile({
    required String name,
    required String password,
  }) async {
    final token = await tokenService.getToken();

    await dio.put(
      "http://192.168.1.74:3000/api/v1/students/update-profile",
      data: {
        "name": name,
        if (password.isNotEmpty) "password": password,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}