import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/cart/presentation/screens/cart_screen.dart';
import 'package:naayu_attire1/features/category/presentation/screens/category_screen.dart';
import 'package:naayu_attire1/features/dashboard/presentation/screens/home_screen.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/profile_screen.dart';
import 'package:naayu_attire1/features/tryon/presentation/screens/tryon_screen.dart';

// Clean Architecture Imports


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    TryOnScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: "Try-On"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
