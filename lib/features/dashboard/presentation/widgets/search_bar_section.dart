import 'package:flutter/material.dart';

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search,
                      color: Colors.grey),
                  SizedBox(width: 8),
                  Text("Search",
                      style: TextStyle(
                          color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.tune, color: Colors.white),
          )
        ],
      ),
    );
  }
}
