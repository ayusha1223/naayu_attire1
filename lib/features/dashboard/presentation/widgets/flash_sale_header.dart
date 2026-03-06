import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/features/category/domain/entities/product.dart';
import 'package:naayu_attire1/features/category/presentation/provider/product_provider.dart';

import 'product_card.dart';

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

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateTime(),
    );
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

    final productProvider = context.watch<ProductProvider>();

    final List<Product> flashProducts =
        productProvider.products
            .where((p) => p.isNew == true)
            .take(5)
            .toList();

    if (flashProducts.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "Flash Sale",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF71A2D4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 16,
                    ),
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

        /// FLASH PRODUCTS
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
                  child: ProductCard(
                    product: product,
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