import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius:
            BorderRadius.circular(40),
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.grid_view, color: Colors.grey),
          Icon(Icons.shopping_bag_outlined,
              color: Colors.grey),
          Icon(Icons.view_in_ar, color: Colors.grey),
          Icon(Icons.person_outline,
              color: Colors.grey),
        ],
      ),
    );
  }
}
