import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/core/services/hive/hive_service.dart';

import 'package:naayu_attire1/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:naayu_attire1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();

  // Setup datasource & repository
  final authDatasource = AuthLocalDatasource(hiveService);
  final authRepository = AuthRepositoryImpl(authDatasource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naayu Attire',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const LoginScreen(),
    );
  }
}
