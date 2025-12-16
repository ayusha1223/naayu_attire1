import 'dart:ui';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;

  const CategoryItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.checkroom, size: 30),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
     ],
);
}
}