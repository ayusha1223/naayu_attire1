import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            CasualPage(),
            CoordPage(),
            WeddingPage(),
            PartyPage(),
            OnePiecePage(),
          ],
        ),
      ),
    );
  }
}
