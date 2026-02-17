import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/presentation/screens/casual_screen.dart';
import 'package:naayu_attire1/features/category/presentation/screens/coord_screen.dart';
import 'package:naayu_attire1/features/category/presentation/screens/onepiece_screen.dart';
import 'package:naayu_attire1/features/category/presentation/screens/party_screen.dart';
import 'package:naayu_attire1/features/category/presentation/screens/wedding_screen.dart';
import 'package:naayu_attire1/features/category/presentation/screens/winter_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          title: const Text("Shop"),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: "Casual"),
              Tab(text: "Co-ord"),
              Tab(text: "Wedding"),
              Tab(text: "Party"),
              Tab(text: "One Piece"),
              Tab(text: "Winter"),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            CasualScreen(),
            CoordScreen(),
            WeddingScreen(),
            PartyScreen(),
            OnePieceScreen(),
            WinterScreen()
          ],
        ),
      ),
    );
  }
}
