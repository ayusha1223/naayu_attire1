import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/category/presentation/widgets/product_grid.dart';
import 'package:naayu_attire1/features/dashboard/presentation/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:naayu_attire1/features/dashboard/presentation/provider/flash_product_provider.dart';
import 'package:naayu_attire1/features/dashboard/presentation/widgets/best_selling_section.dart';
import 'package:naayu_attire1/features/dashboard/presentation/widgets/service_footer_section.dart';
import '../widgets/flash_sale_header.dart';
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

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();

    // 🔥 LOAD ALL PRODUCTS FOR SEARCH
    Future.microtask(() {
      context.read<FlashProductProvider>().loadAllProducts();
    });

    _startShakeDetection();
  }

  void _startShakeDetection() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {

      double threshold = 18.0;

      if (event.x.abs() > threshold ||
          event.y.abs() > threshold ||
          event.z.abs() > threshold) {

        final now = DateTime.now();

        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > const Duration(seconds: 3)) {

          _lastShakeTime = now;
          _showReportBottomSheet();
        }
      }
    });
  }

  void _showReportBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Report a Technical Problem",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We detected unusual device movement. "
                "If you're experiencing any technical issue, "
                "please report it to our support team.",
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xffF6F6F6),
    body: SafeArea(
      child: Consumer<FlashProductProvider>(
        builder: (context, provider, _) {

          return CustomScrollView(
            slivers: [

              /// 🔹 HEADER ALWAYS VISIBLE
              SliverToBoxAdapter(
                child: Column(
                  children: const [
                    SizedBox(height: 1),
                    LocationHeader(),
                    SearchBarSection(),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              /// 🔥 IF SEARCHING → SHOW ONLY SEARCH RESULTS
              if (provider.isSearching)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = provider.allProducts[index];
                        return ProductCard(product: product);
                      },
                      childCount: provider.allProducts.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.48,
                    ),
                  ),
                )
              else ...[

                /// 🔹 NORMAL DASHBOARD CONTENT
                SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      BannerSection(imagePath: ''),
                      SizedBox(height: 15),
                      FeatureTabSection(),
                      SizedBox(height: 30),
                      FlashSaleHeader(),
                      SizedBox(height: 20),
                      PromoBox(
                        image: "assets/images/splash/promo1.jpeg",
                        title: "UPTO 30% OFF",
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = provider.allProducts[index];
                        return ProductCard(product: product);
                      },
                      childCount: provider.allProducts.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.48,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      SizedBox(height: 25),
                      PromoBox(
                        image: "assets/images/splash/promo2.jpeg",
                        title: "FLAT 16% OFF",
                      ),
                      SizedBox(height: 30),
                      ServiceFooterSection(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    ),
  );
}
}