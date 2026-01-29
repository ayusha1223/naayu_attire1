import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';

  TokenService(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }
}
