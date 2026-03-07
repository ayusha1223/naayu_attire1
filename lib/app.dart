import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/onboarding/presentation/screens/onboarding_main.dart';
import 'package:naayu_attire1/navigation/main_navigation.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/theme_provider.dart';

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naayu Attire',

      themeMode: themeProvider.themeMode,

      /// LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ),
      ),

      /// DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ),
      ),


home: const OnboardingMain(),

// home: isLoggedIn
//     ? const MainNavigation()
//     : const OnboardingMain(),
    );
  }
}