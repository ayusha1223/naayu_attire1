import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository authRepository;

  AuthViewModel(this.authRepository);

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
    String password, {required String fullName}
  ) async {
    _setLoading(true);
    _setError(null); // 🔥 CLEAR OLD ERROR

    final result = await authRepository.register(
      AuthEntity(
        fullName: name,
        email: email,
        password: password, id: '',
      ),
    );

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (_) {
        _setError(null); // 🔥 CLEAR ERROR ON SUCCESS
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
      (_) => true,
    );
  }

  // ---------------- LOGOUT (future) ----------------
  // Future<void> logout() async {
  //   await authRepository.logout();
  // }
}
