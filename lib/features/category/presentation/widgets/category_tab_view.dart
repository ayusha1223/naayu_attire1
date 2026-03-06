import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/presentation/screens/category_screen.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [

        CategoryScreen(
          category: "casual",
          title: "Casual",
        ),

        CategoryScreen(
          category: "coord",
          title: "Coord Sets",
        ),

        CategoryScreen(
          category: "wedding",
          title: "Wedding",
        ),

        CategoryScreen(
          category: "party",
          title: "Party",
        ),

        CategoryScreen(
          category: "onepiece",
          title: "One Piece",
        ),

        CategoryScreen(
          category: "winter",
          title: "Winter",
        ),
      ],
    );
  }
}