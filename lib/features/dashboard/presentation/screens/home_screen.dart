import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/dashboard/presentation/widgets/best_selling_section.dart';
import 'package:naayu_attire1/features/dashboard/presentation/widgets/service_footer_section.dart';
import '../widgets/flash_sale_header.dart';
import '../widgets/product_grid.dart';
import '../widgets/location_header.dart';
import '../widgets/search_bar_section.dart';
import '../widgets/banner_section.dart';
import '../widgets/feature_tab_section.dart';
import '../widgets/promo_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Duration timeLeft = const Duration(days: 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [

              SizedBox(height: 1),

              LocationHeader(),
              
              SearchBarSection(),
              SizedBox(height: 20),

              BannerSection(imagePath: '',),
              SizedBox(height: 15),

              FeatureTabSection(),
              const SizedBox(height: 30),

              const FlashSaleHeader(),
              SizedBox(height: 20),
            
                  PromoBox(
      image: "assets/images/splash/promo1.jpeg",
      title: "UPTO 30% OFF",
    ),

    const SizedBox(height: 25),

    BestSellingSection(),   // 👈 HERE

    const SizedBox(height: 25),

    PromoBox(
      image: "assets/images/splash/promo2.jpeg",
      title: "FLAT 16% OFF",
    ),
    const SizedBox(height: 30),
              ServiceFooterSection()
            ],
          ),
        ),
      ),
    );
  }
}
