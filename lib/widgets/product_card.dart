import 'package:flutter/material.dart';

Widget productList() {
  final products = [
    "assets/images/image6.jpeg",
    "assets/images/image7.jpeg",
    "assets/images/image8.jpeg",
    "assets/images/image9.jpeg",
  ];

  return SizedBox(
    height: 210,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Container(
          width: 140,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(products[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Rs. 2,999",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
