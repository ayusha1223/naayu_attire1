import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/profile_screen.dart';
import 'package:naayu_attire1/features/tryon/presentation/screens/tryon_screen.dart';
import 'package:naayu_attire1/widgets/category_item.dart';
import 'package:naayu_attire1/widgets/product_card.dart';
import 'package:naayu_attire1/widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/videos/hero.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget productList() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ProductCard(
            image: "assets/images/splash/image1.jpeg",
            title: "Elegant Kurti",
            price: "Rs 2999",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔘 Floating Button
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

      // ⬇️ Bottom Navigation
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
              const SizedBox(width: 40),
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

              // 🔍 Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14),
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

              // 🎥 HERO VIDEO SECTION
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [

                        // VIDEO
                      // 🎥 HERO VIDEO SECTION
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Container(
    height: 250,
    child: _controller.value.isInitialized
        ? VideoPlayer(_controller)
        : const Center(
            child: CircularProgressIndicator(),
          ),
  ),
),
                        // DARK OVERLAY
                        Container(
                          color: Colors.black.withOpacity(0.35),
                        ),

                        // TEXT
                        const Center(
                          child: Text(
                            "Get 50% off\non your first order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🧥 Categories
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: const [
                    CategoryItem(
                      title: "Best Selling",
                      image:
                          "assets/images/splash/image2.jpeg",
                    ),
                    CategoryItem(
                      title: "Party Wear",
                      image:
                          "assets/images/splash/image3.jpeg",
                    ),
                    CategoryItem(
                      title: "Casual Wear",
                      image:
                          "assets/images/splash/image4.jpeg",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🆕 Collection Banner
          // 🆕 NEW COLLECTION VIDEO BANNER
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Container(
    height: 170,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [

          /// VIDEO BACKGROUND
          _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),

          /// LIGHT OVERLAY (like image)
          Container(
            color: const Color(0xFFBFA58E).withOpacity(0.35),
          ),

          /// LEFT TEXT CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "New Collection",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Discount 50% for\n the first transaction",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Shop Now",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
