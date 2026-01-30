import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email) {
  return email.contains('@');
}

bool isValidPassword(String password) {
  return password.length >= 6;
}

void main() {
  test('Empty email should be invalid', () {
    expect(isValidEmail(''), false);
  });

  test('Valid email should return true', () {
    expect(isValidEmail('test@gmail.com'), true);
  });

  test('Short password should be invalid', () {
    expect(isValidPassword('123'), false);
  });

  test('Valid password should be valid', () {
    expect(isValidPassword('123456'), true);
  });
}
