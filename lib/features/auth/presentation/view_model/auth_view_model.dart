import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository authRepository;
  final TokenService tokenService;

  AuthViewModel(this.authRepository, this.tokenService);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------- STATE HELPERS ----------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ---------------- SIGN UP ----------------
  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    _setLoading(true);
    _setError(null);

    final result = await authRepository.register(
      AuthEntity(
        id: '',
        fullName: name,
        email: email,
        password: password,
        token: '',
      ),
    );

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (_) {
        _setError(null);
        return true;
      },
    );
  }

  // ---------------- LOGIN ----------------
  Future<bool> login({
  required String email,
  required String password,
}) async {
  _setLoading(true);
  _setError(null);

  final result = await authRepository.login(email, password);

  _setLoading(false);

  return result.fold(
    (failure) {
      _setError(failure.message);
      return false;
    },
    (authEntity) async {
  print("🔥 SAVED TOKEN: ${authEntity.token}");

  await tokenService.saveToken(authEntity.token);
  return true;
}

  );
}


  // ---------------- LOGOUT (future) ----------------
  Future<void> logout(BuildContext context) async {
    final tokenService =
        Provider.of<TokenService>(context, listen: false);

    await tokenService.removeToken();
  }
}
