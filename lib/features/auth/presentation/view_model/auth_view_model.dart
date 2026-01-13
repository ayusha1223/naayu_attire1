import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';
import 'package:uuid/uuid.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository authRepository;

  AuthViewModel(this.authRepository);

  final _uuid = const Uuid();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// ---------------- SIGN UP ----------------
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    final entity = AuthEntity(
      id: _uuid.v4(), // ✅ GENERATED ID
      fullName: fullName,
      email: email,
      password: password,
    );

    final result = await authRepository.register(entity);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (success) => success,
    );
  }

  /// ---------------- LOGIN ----------------
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
      (_) => true,
    );
  }

  /// ---------------- LOGOUT ----------------
  // Future<void> logout() async {
  //   await authRepository.logout();
  // }
}
