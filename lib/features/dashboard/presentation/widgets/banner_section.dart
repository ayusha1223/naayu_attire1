import 'package:flutter/material.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [

              Image.asset(
                "assets/images/home/home1.jpeg",
                fit: BoxFit.cover,
              ),

              Container(
                color: const Color(0xFFEADFD6)
                    .withOpacity(0.5),
              ),

              const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      "New Collection",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Discount 50% for\n the first transaction",
                      style:
                          TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
