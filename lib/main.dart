import 'package:flutter/material.dart';
import 'package:naayu_attire1/app.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/core/providers/theme_provider.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:naayu_attire1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// 🔥 Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp();

  // 🔔 Set background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// 🔔 Request notification permission
FirebaseMessaging messaging = FirebaseMessaging.instance;
await messaging.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);

// 🔑 Get FCM token (IMPORTANT)
String? token = await FirebaseMessaging.instance.getToken();
print("FCM TOKEN: $token");

// 🔔 Foreground message listener
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print("Foreground message received: ${message.notification?.title}");
});

  final sharedPreferences = await SharedPreferences.getInstance();
  final apiClient = ApiClient();
  final tokenService = TokenService(sharedPreferences);

  final authDatasource = AuthRemoteDatasourceImpl(apiClient);
  final authRepository = AuthRepositoryImpl(authDatasource);

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
          create: (_) => ShopProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}