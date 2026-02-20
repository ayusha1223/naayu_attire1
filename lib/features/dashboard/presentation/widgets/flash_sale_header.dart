import 'dart:async';
import 'package:flutter/material.dart';
import 'premium_product_card.dart';

class FlashProduct {
  final String imagePath;
  final String title;
  final int price;
  final int oldPrice;

  FlashProduct({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
  });
}

class FlashSaleHeader extends StatefulWidget {
  const FlashSaleHeader({super.key});

  @override
  State<FlashSaleHeader> createState() => _FlashSaleHeaderState();
}

class _FlashSaleHeaderState extends State<FlashSaleHeader> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  final DateTime _endDate =
      DateTime.now().add(const Duration(days: 25));

  final List<FlashProduct> flashProducts = [
    FlashProduct(
      imagePath: "assets/images/splash/onepiece2.png",
      title: "Chaubandi",
      price: 1200,
      oldPrice: 1999,
    ),
    FlashProduct(
      imagePath: "assets/images/onepiece/onepiece3.png",
      title: "Cotton",
      price: 999,
      oldPrice: 1299,
    ),
    FlashProduct(
      imagePath: "assets/images/splash/onepiece4.png",
      title: "Royal Bridal",
      price: 1799,
      oldPrice: 2399,
    ),
     FlashProduct(
      imagePath: "assets/images/onepiece/onepiece6.png",
      title: "Chaubandi",
      price: 1200,
      oldPrice: 1999,
    ),
    FlashProduct(
      imagePath: "assets/images/onepiece/onepiece7.png",
      title: "Cotton",
      price: 999,
      oldPrice: 1299,
    ),
    FlashProduct(
      imagePath: "assets/images/onepiece/onepiece8.png",
      title: "Royal Bridal",
      price: 1799,
      oldPrice: 2399,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  void _updateTime() {
    final difference = _endDate.difference(DateTime.now());

    if (difference.isNegative) {
      _timer.cancel();
      setState(() {
        _timeLeft = Duration.zero;
      });
    } else {
      setState(() {
        _timeLeft = difference;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 HEADER WITH TIMER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "Flash Sale",
                style: TextStyle(
                  fontFamily: "Times New Roman",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 113, 162, 212),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "${_timeLeft.inDays}d "
                      "${_timeLeft.inHours.remainder(24)}h "
                      "${_timeLeft.inMinutes.remainder(60)}m "
                      "${_timeLeft.inSeconds.remainder(60)}s",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        /// 🔥 HORIZONTAL PRODUCT LIST
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: flashProducts.length,
            itemBuilder: (context, index) {

              final product = flashProducts[index];

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 170,
                  child: PremiumProductCard(
                    image: product.imagePath,
                    title: product.title,
                    price: product.price,
                    oldPrice: product.oldPrice,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 25),
      ],
    );
  }
}