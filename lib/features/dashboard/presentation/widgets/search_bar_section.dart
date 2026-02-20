import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/dashboard/presentation/provider/flash_product_provider.dart';
import 'package:provider/provider.dart';


class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
  decoration: const InputDecoration(
    hintText: "Search products...",
    border: InputBorder.none,
    icon: Icon(Icons.search),
  ),
  onChanged: (value) {
    context
        .read<FlashProductProvider>()
        .searchProduct(value);
  },
),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          )
        ],
      ),
    );
  }
}