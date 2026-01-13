import '../models/auth_remote_model.dart';

abstract interface class IAuthDatasource {
  Future<bool> register(
    String name,
    String email,
    String password,
  );

  Future<AuthRemoteModel> login(
    String email,
    String password,
  );
}
