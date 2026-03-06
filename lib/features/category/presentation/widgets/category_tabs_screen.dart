import 'package:flutter/material.dart';
import 'category_tab_view.dart';

class CategoryTabsScreen extends StatelessWidget {
  const CategoryTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Categories"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Casual"),
              Tab(text: "Coord"),
              Tab(text: "Wedding"),
              Tab(text: "Party"),
              Tab(text: "One Piece"),
              Tab(text: "Winter"),
            ],
          ),
        ),
        body: const CategoryTabView(),
      ),
    );
  }
}