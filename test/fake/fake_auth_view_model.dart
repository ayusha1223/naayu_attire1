import 'package:flutter/material.dart';

class FakeAuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    return true;
  }

  void clearError() {
    errorMessage = null;
  }
}
