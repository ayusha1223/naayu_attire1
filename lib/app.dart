import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/onboarding/presentation/screens/onboarding_main.dart';
import 'package:naayu_attire1/navigation/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingMain(),
    );
  }
}
