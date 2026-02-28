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
  int? selectedDressIndex; // ✅ null = naked avatar

  final List<DressModel> dresses = [
    DressModel(
      image: "assets/images/tryon/view1.png",
      widthFactor: 0.90,
      heightFactor: 0.62,
      offsetX: -2,
      offsetY: 86,
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
      widthFactor: 0.65,
      heightFactor: 0.75,
      offsetX: -5,
      offsetY: 25,
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
      widthFactor: 0.92,
      heightFactor: 0.80,
      offsetX: -8,
      offsetY: 6,
    ),
  ];

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
      ),
      body: Column(
        children: [

          /// ===== TOP HORIZONTAL DRESS LIST =====
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dresses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDressIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedDressIndex == index
                            ? Colors.pink
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      dresses[index].image,
                      width: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),

          /// ===== AVATAR AREA =====
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [

                /// Avatar (Always Visible)
                Image.asset(
                  'assets/images/tryon/avatar.png',
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.85,
                  fit: BoxFit.contain,
                ),

                /// Dress (Only if selected)
                if (selectedDressIndex != null)
                  Transform.translate(
                    offset: Offset(
                      dresses[selectedDressIndex!].offsetX,
                      dresses[selectedDressIndex!].offsetY,
                    ),
                    child: Image.asset(
                      dresses[selectedDressIndex!].image,
                      width: screenWidth *
                          dresses[selectedDressIndex!].widthFactor,
                      height: screenHeight *
                          dresses[selectedDressIndex!].heightFactor,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}