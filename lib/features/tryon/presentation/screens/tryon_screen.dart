import 'package:flutter/material.dart';

class DressModel {
  final String image;
  final double widthFactor;
  final double heightFactor;
  final double offsetX;
  final double offsetY;

  DressModel({
    required this.image,
    required this.widthFactor,
    required this.heightFactor,
    required this.offsetX,
    required this.offsetY,
  });
}
class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  int currentDressIndex = 0;
  final PageController _pageController = PageController();

  final List<DressModel> dresses = [
  DressModel(
    image: "assets/images/tryon/view1.png",
    widthFactor: 0.92,
    heightFactor: 0.60,
    offsetX:-2,
    offsetY: 75,
  ),
  DressModel(
    image: "assets/images/tryon/view2.png",
    widthFactor: 0.80,
    heightFactor: 0.70,
    offsetX: -5,
    offsetY: 43,
  ),
  DressModel(
    image: "assets/images/tryon/view3.png",
    widthFactor: 0.78,
    heightFactor: 0.60,
    offsetX: -2,
    offsetY: 45,
  ),
  DressModel(
    image: "assets/images/tryon/view4.png",
    widthFactor: 0.80,
    heightFactor: 2.80,
    offsetX: 0,
    offsetY: 5,
  ),
  DressModel(
    image: "assets/images/tryon/view5.png",
    widthFactor: 0.75,
    heightFactor: 0.65,
    offsetX: 5,
    offsetY: 45,
  ),
  DressModel(
    image: "assets/images/tryon/view6.png",
    widthFactor: 0.77,
    heightFactor: 0.67,
    offsetX: -8,
    offsetY: 50,
  ),
  DressModel(
    image: "assets/images/tryon/view7.png",
    widthFactor: 0.90,
    heightFactor: 0.78,
    offsetX: -5,
    offsetY: 16,
  ),
  DressModel(
    image: "assets/images/tryon/view8.png",
    widthFactor: 0.79,
    heightFactor: 0.69,
    offsetX: -4,
    offsetY: 55,
  ),
];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Virtual Try On",
          style: TextStyle(
            color: Color(0xFFE91E63),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [

          /// ===== AVATAR =====
          Center(
            child: Image.asset(
              'assets/images/tryon/avatar.png',   // ✅ corrected path
              width: screenWidth * 0.95,
              height: screenHeight * 0.85,
              fit: BoxFit.contain,
            ),
          ),

          /// ===== DRESS VIEW =====
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: dresses.length,
              onPageChanged: (index) {
                setState(() {
                  currentDressIndex = index;
                });
              },
          itemBuilder: (context, index) {
  final dress = dresses[index];

  return Center(
    child: Transform.translate(
      offset: Offset(dress.offsetX, dress.offsetY),
      child: Image.asset(
        dress.image,
        width: screenWidth * dress.widthFactor,
        height: screenHeight * dress.heightFactor,
        fit: BoxFit.contain,
      ),
    ),
  );
},

            ),
          ),

          /// ===== DRESS COUNTER =====
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Dress ${currentDressIndex + 1} / ${dresses.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          /// ===== LEFT ARROW =====
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 30),
                onPressed: currentDressIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration:
                              const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                color: Colors.black54,
              ),
            ),
          ),

          /// ===== RIGHT ARROW =====
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 30),
                onPressed: currentDressIndex <
                        dresses.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration:
                              const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
