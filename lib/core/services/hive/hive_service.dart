import 'package:hive_flutter/hive_flutter.dart';
import 'package:naayu_attire1/core/constants/hive_table_constants.dart';
import 'package:path_provider/path_provider.dart';
import '../../../features/auth/data/models/auth_hive_model.dart';

class HiveService {
  // Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';

    await Hive.initFlutter(path);

    // Register adapters
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    // Open auth box
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  // Save user (Signup)
  Future<void> saveUser(AuthHiveModel user) async {
    final box = Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
    await box.put(user.email, user);
  }

  // Login user
  AuthHiveModel? loginUser(String email, String password) {
    final box = Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
    final user = box.get(email);

    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  // Get current user (simple version)
  AuthHiveModel? getUser(String email) {
    final box = Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
    return box.get(email);
  }

  // Logout (local app → nothing to clear yet)
  Future<void> logout() async {
    // Later you can clear session data here
  }
}
