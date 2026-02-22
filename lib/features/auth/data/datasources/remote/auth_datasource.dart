import 'package:naayu_attire1/features/auth/data/models/auth_remote_model.dart';

abstract class IAuthDatasource {
  Future<bool> register(
    String name,
    String email,
    String password,
  );

  Future<AuthRemoteModel> login(
    String email,
    String password,
  );

  Future<bool> forgotPassword(String email);

  Future<bool> verifyOtp(String email, String otp);

  Future<bool> resetPassword(
    String email,
    String newPassword,
  );
}