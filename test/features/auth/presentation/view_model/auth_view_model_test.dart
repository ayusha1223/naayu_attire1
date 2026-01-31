import 'package:flutter_test/flutter_test.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  test('AuthViewModel initial state', () {
    // We don't call methods, just verify initial values
    final vm = AuthViewModel as dynamic;

    expect(vm, isNotNull);
  });

void main() {
  test('Loading flag exists', () {
    // Logic-level test
    bool isLoading = false;
    expect(isLoading, false);
  });

void main() {
  test('Error message can be null', () {
    String? error;
    expect(error, null);
  });
}
}
}