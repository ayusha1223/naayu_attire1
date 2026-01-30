import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email) {
  return email.contains('@') && email.isNotEmpty;
}

bool isValidPassword(String password) {
  return password.length >= 6;
}

bool passwordsMatch(String p1, String p2) {
  return p1 == p2;
}

void main() {
  test('Login: empty email invalid', () {
    expect(isValidEmail(''), false);
  });

  test('Login: valid email accepted', () {
    expect(isValidEmail('user@gmail.com'), true);
  });

  test('Signup: empty password invalid', () {
    expect(isValidPassword(''), false);
  });

  test('Signup: short password invalid', () {
    expect(isValidPassword('123'), false);
  });

  test('Signup: password match', () {
    expect(passwordsMatch('123456', '123456'), true);
  });
}
