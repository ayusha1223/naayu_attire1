import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email) {
  return email.contains('@');
}

bool isValidPassword(String password) {
  return password.length >= 6;
}

bool doPasswordsMatch(String p1, String p2) {
  return p1 == p2;
}

void main() {
  test('Login: empty email is invalid', () {
    expect(isValidEmail(''), false);
  });

  test('Login: empty password is invalid', () {
    expect(isValidPassword(''), false);
  });

  test('Signup: valid email format', () {
    expect(isValidEmail('user@gmail.com'), true);
  });

  test('Signup: password length must be >= 6', () {
    expect(isValidPassword('12345'), false);
  });

  test('Signup: password and confirm password must match', () {
    expect(doPasswordsMatch('123456', '123456'), true);
  });
}
