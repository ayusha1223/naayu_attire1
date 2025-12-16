import 'package:flutter/material.dart';
import 'package:naayu_attire1/widgets/category_item.dart';
import 'package:naayu_attire1/widgets/product_card.dart';
import 'package:naayu_attire1/widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f1ee),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔍 Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 10),
                            Text(
                              "Search",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.favorite_border),
                  ],
                ),
              ),

              // 🎉 Banner Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get 50% off",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "On your first order",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Wishlist now",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🧥 Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CategoryItem(title: "New Arrivals"),
                    CategoryItem(title: "Party Wear"),
                    CategoryItem(title: "Casual Wear"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🆕 New Collection
              sectionTitle("New Collection"),
              productList(),

              // 🔥 Best Red Selling
              sectionTitle("Best Red Selling"),
              productList(),

              // ❄ Winter Collection
              sectionTitle("Winter Collection"),
              productList(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
