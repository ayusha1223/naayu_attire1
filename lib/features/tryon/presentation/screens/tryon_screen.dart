import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';


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
      offsetX: -2,
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
      heightFactor: 0.70, // FIXED (was 2.80)
      offsetX: 0,
      offsetY: 40,
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
      body: PageView.builder(
        controller: _pageController,
        itemCount: dresses.length,
        onPageChanged: (index) {
          setState(() {
            currentDressIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final dress = dresses[index];

          final product = ProductModel(
            id: index.toString(),
            image: dress.image,
            name: "Kurtha ${index + 1}",
            price: 1999.0, color: '',
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// Avatar + Dress Stack
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/tryon/avatar.png',
                    width: screenWidth * 0.95,
                    height: screenHeight * 0.85,
                    fit: BoxFit.contain,
                  ),
                  Transform.translate(
                    offset: Offset(dress.offsetX, dress.offsetY),
                    child: Image.asset(
                      dress.image,
                      width: screenWidth * dress.widthFactor,
                      height: screenHeight * dress.heightFactor,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "Rs. ${product.price}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// Favorite
                  Consumer<ShopProvider>(
                    builder: (context, shop, _) {
                      final isFav = shop.isFavorite(product);

                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          shop.toggleFavorite(product);
                        },
                      );
                    },
                  ),

                  const SizedBox(width: 20),

                  /// Add To Cart
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                    ),
                    onPressed: () {
                      context.read<ShopProvider>().addToCart(product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to Cart"),
                        ),
                      );
                    },
                    child: const Text("Add to Cart"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
