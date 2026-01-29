import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider to expose TokenService
final tokenServiceProvider = Provider<TokenService>((ref) {
  throw UnimplementedError('TokenService not initialized');
});

/// Token Service
class TokenService {
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';

  TokenService({required SharedPreferences prefs}) : _prefs = prefs;

  /// Save JWT token after login
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Get token for authenticated API calls
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Remove token on logout
  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }
}
