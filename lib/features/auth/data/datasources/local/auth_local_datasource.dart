import 'package:naayu_attire1/core/services/hive/hive_service.dart';
import 'package:naayu_attire1/features/auth/data/datasources/auth_datasource.dart';
import 'package:naayu_attire1/features/auth/data/models/auth_hive_model.dart';

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService hiveService;

  AuthLocalDatasource(this.hiveService);

  @override
  Future<bool> register(AuthHiveModel model) async {
    // ✅ Safety check (email must not be null)
    if (model.email == null || model.email!.isEmpty) {
      return false;
    }

    // check if email already exists
    final exists = await isEmailExists(model.email!);
    if (exists) {
      return false;
    }

    await hiveService.saveUser(model);
    return true;
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return null;
    }

    return await hiveService.loginUser(email, password);
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    // 🔹 Session logic not implemented yet
    return null;
  }

  @override
  Future<bool> logout() async {
    // 🔹 No local logout logic yet
    return true;
  }

  @override
  Future<bool> isEmailExists(String email) async {
    final user = await hiveService.getUser(email);
    return user != null;
  }
}
