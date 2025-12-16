import 'package:flutter/material.dart';
import 'package:naayu_attire1/widgets/category_item.dart';
import 'package:naayu_attire1/widgets/product_card.dart';
import 'package:naayu_attire1/widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔍 Top Search + Icons
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

              // 🎉 TOP BANNER — IMAGE 1
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Get 50% off\non your first order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Chip(
                            backgroundColor: Color(0xff918C8C),
                            label: Text(
                              "Wishlist now",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🧥 Category Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CategoryItem(title: "Best Selling", image: 'image2',),
                    CategoryItem(title: "Party Wear", image: 'image3',),
                    CategoryItem(title: "Casual Wear", image: 'image4',),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🆕 New Collection Banner (placeholder stays same)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "New Collection",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🆕 New Collection Products
              sectionTitle("New Collection"),
              productList(),

              // 🔥 Best Red Selling
              sectionTitle("Best Red Selling"),
              productList(),

              // ❄ Winter Collection
              sectionTitle("Winter Collection"),
              productList(),

              const SizedBox(height: 20),

              // 🖼 FINAL BANNER — IMAGE 12
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.35),
                    ),
                    child: const Center(
                      child: Text(
                        "Featured Brand / Promotion",
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
            ],
          ),
        ),
      ),
    );
  }
}
