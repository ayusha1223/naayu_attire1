import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/bottom_screens/presentation/screens/profile_screen.dart';
import 'package:naayu_attire1/features/bottom_screens/presentation/screens/tryon_screen.dart';

import 'package:naayu_attire1/widgets/category_item.dart';
import 'package:naayu_attire1/widgets/product_card.dart';
import 'package:naayu_attire1/widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7c5cff),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TryOnScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ⬇️ BOTTOM NAV BAR
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),

              const SizedBox(width: 40), // space for FAB

              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // 📄 BODY
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔍 Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Search",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffA19C9C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.notifications_none),
                    const SizedBox(width: 12),
                    const Icon(Icons.favorite_border),
                  ],
                ),
              ),

              // 🎉 Top banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/image1.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(0.35),
                    ),
                    child: const Center(
                      child: Text(
                        "Get 50% off\non your first order",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🧥 Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CategoryItem(
                      title: "Best Selling",
                      image: "assets/images/image2.jpeg",
                    ),
                    CategoryItem(
                      title: "Party Wear",
                      image: "assets/images/image3.jpeg",
                    ),
                    CategoryItem(
                      title: "Casual Wear",
                      image: "assets/images/image4.jpeg",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🆕 New collection banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/image5.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              sectionTitle("New Collection"),
              productList(),

              sectionTitle("Best Red Selling"),
              productList(),

              sectionTitle("Winter Collection"),
              productList(),

              const SizedBox(height: 20),

              // 🔻 Final banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/image12.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
