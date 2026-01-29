import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:naayu_attire1/features/onboarding/presentation/screens/onboarding_main.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final apiClient = ApiClient();

  final authDatasource = AuthRemoteDatasourceImpl(apiClient);

  
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
      home: const OnboardingMain(),
    );
  }
}
