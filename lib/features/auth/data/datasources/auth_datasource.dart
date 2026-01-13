import 'package:naayu_attire1/features/auth/data/models/auth_api_model.dart';


abstract interface class IAuthDatasource {
  /// Register user via API
  Future<bool> register(
    String name,
    String email,
    String password,
  );

  /// Login user via API
  Future<AuthRemoteModel> login(
    String email,
    String password,
  );
}
