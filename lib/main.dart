import 'package:flutter/material.dart';
import 'package:naayu_attire1/app.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/core/providers/theme_provider.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:naayu_attire1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/dashboard/presentation/provider/flash_product_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// FIREBASE
  await Firebase.initializeApp();

  /// HIVE
  await Hive.initFlutter();
  await Hive.openBox("cartBox");
  await Hive.openBox("wishlistBox");
  await Hive.openBox("authBox");

  /// NOTIFICATIONS
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  /// SERVICES
  final sharedPreferences = await SharedPreferences.getInstance();
final tokenService = TokenService(sharedPreferences);
final apiClient = ApiClient(tokenService);

  final authDatasource = AuthRemoteDatasourceImpl(apiClient);
  final authRepository = AuthRepositoryImpl(authDatasource);

  /// CHECK LOGIN STATE
  bool isLoggedIn =
      sharedPreferences.getBool("isLoggedIn") ?? false;

  runApp(
  MultiProvider(
    providers: [

      Provider<TokenService>(
        create: (_) => tokenService,
      ),

      ChangeNotifierProvider(
        create: (_) =>
            AuthViewModel(authRepository, tokenService),
      ),

      ChangeNotifierProvider(
        lazy: false,
        create: (_) {
          final provider = ShopProvider(tokenService, apiClient);

          Future.microtask(() async {
            await provider.initializeUser();
          });

          return provider;
        },
      ),

      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      ),

      // 🔥 ADD THIS
      ChangeNotifierProvider(
        create: (_) => FlashProductProvider(),
      ),

    ],
    child: MyApp(isLoggedIn: isLoggedIn),
  ),
);
}