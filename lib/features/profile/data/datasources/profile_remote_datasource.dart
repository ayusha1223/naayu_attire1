import 'package:dio/dio.dart';

class ProfileRemoteDatasource {

  final Dio dio;

  ProfileRemoteDatasource(this.dio);

  Future<void> updateProfile(String name, String password) async {

    await dio.put(
      "/students/update-profile",
      data: {
        "name": name,
        "password": password
      },
    );
  }
}