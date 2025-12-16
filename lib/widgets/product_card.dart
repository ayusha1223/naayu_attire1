import 'package:flutter/material.dart';

Widget productList() {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          width: 140,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 40),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Product Name",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text("₹ 2,999", style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
),
);
}