import 'package:flutter/material.dart';

class FeatureTabSection extends StatefulWidget {
  const FeatureTabSection({super.key});

  @override
  State<FeatureTabSection> createState() => _FeatureTabSectionState();
}

class _FeatureTabSectionState extends State<FeatureTabSection> {
  int selectedIndex = 0;

  final List<String> bestSelling = [
    "assets/images/splash/wedding1.png",
    "assets/images/splash/wedding3.png",
    "assets/images/splash/wedding4.png",
    "assets/images/splash/wedding5.png",
  ];

  final List<String> newArrivals = [
    "assets/images/splash/wedding6.png",
    "assets/images/splash/wedding7.png",
    "assets/images/splash/wedding8.png",
    "assets/images/splash/wedding9.png",
  ];

  final List<String> trending = [
    "assets/images/splash/wedding10.png",
    "assets/images/splash/wedding11.png",
    "assets/images/splash/wedding12.png",
    "assets/images/splash/wedding13.png",
  ];

  List<String> get currentList {
    if (selectedIndex == 0) return bestSelling;
    if (selectedIndex == 1) return newArrivals;
    return trending;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// TAB BUTTONS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTab("Best Selling", 0),
              _buildTab("New Arrivals", 1),
              _buildTab("Trending", 2),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// HORIZONTAL IMAGE LIST (Animated)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: SizedBox(
            key: ValueKey(selectedIndex),
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: currentList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      currentList[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.brown : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
