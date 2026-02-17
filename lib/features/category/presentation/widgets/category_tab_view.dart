import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/presentation/screens/onepiece_screen.dart';
import 'package:naayu_attire1/features/category/presentation/screens/winter_screen.dart';
import '../screens/casual_screen.dart';
import '../screens/coord_screen.dart';
import '../screens/wedding_screen.dart';
import '../screens/party_screen.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        CasualScreen(),
        CoordScreen(),
        WeddingScreen(),
        PartyScreen(),
        OnePieceScreen(),
        WinterScreen(),
      ],
    );
  }
}
