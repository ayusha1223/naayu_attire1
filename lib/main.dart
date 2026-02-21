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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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