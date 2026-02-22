import 'package:hive/hive.dart';

class TokenService {
  final Box authBox = Hive.box("authBox");

  void saveToken(String token) {
    authBox.put("token", token);
  }

  String? getToken() {
    return authBox.get("token");
  }

  void clearToken() {
    authBox.delete("token");
  }
}