import 'package:naayu_attire1/features/auth/data/models/auth_remote_model.dart';

/// Remote Auth Datasource (API only)
abstract interface class IAuthDatasource {
  /// Signup
  Future<bool> register(
    String name,
    String email,
    String password,
  );

  /// Login
  Future<AuthRemoteModel> login(
    String email,
    String password,
  );
}
