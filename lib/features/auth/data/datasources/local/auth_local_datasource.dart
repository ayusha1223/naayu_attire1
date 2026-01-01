import 'package:naayu_attire1/core/services/hive/hive_service.dart';
import 'package:naayu_attire1/features/auth/data/datasources/auth_datasource.dart';
import 'package:naayu_attire1/features/auth/data/models/auth_hive_model.dart';

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService hiveService;

  AuthLocalDatasource(this.hiveService);

  @override
  Future<bool> register(AuthHiveModel model) async {
    // check if email already exists
    final exists = await isEmailExists(model.email);
    if (exists) {
      return false;
    }

    await hiveService.saveUser(model);
    return true;
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    return hiveService.loginUser(email, password);
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    // For now: no session management
    return null;
  }

  @override
  Future<bool> logout() async {
    // No local logout logic yet
    return true;
  }

  @override
  Future<bool> isEmailExists(String email) async {
    final user = hiveService.getUser(email);
    return user != null;
  }
}
