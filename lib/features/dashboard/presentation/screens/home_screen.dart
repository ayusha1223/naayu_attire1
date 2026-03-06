import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

import 'package:naayu_attire1/features/dashboard/presentation/widgets/product_card.dart';
import 'package:naayu_attire1/features/dashboard/presentation/provider/flash_product_provider.dart';
import 'package:naayu_attire1/features/category/presentation/provider/product_provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';

import '../widgets/flash_sale_header.dart';
import '../widgets/location_header.dart';
import '../widgets/search_bar_section.dart';
import '../widgets/banner_section.dart';
import '../widgets/feature_tab_section.dart';
import '../widgets/promo_section.dart';
import '../widgets/service_footer_section.dart';

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

    Future.microtask(() {
      context.read<ShopProvider>().initializeUser();
      context.read<ProductProvider>().fetchProducts();
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

        return const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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

        child: Consumer3<
            FlashProductProvider,
            ShopProvider,
            ProductProvider>(

          builder: (context, flashProvider, shop, productProvider, _) {

            final homeProducts = productProvider.products;

            /// 🔴 NO INTERNET + NO CACHE
/// 🔴 NO INTERNET + NO CACHE
if (shop.isOffline && homeProducts.isEmpty){

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Icon(
                      Icons.wifi_off,
                      size: 50,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "No connection\nTry again",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductProvider>().fetchProducts();
                      },
                      child: const Text("Retry"),
                    )

                  ],
                ),
              );
            }

            return CustomScrollView(

              slivers: [

                /// HEADER
                const SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 1),
                      LocationHeader(),
                      SearchBarSection(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                /// 🟡 OFFLINE BANNER
                if (shop.isOffline)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off, size: 16),
                          SizedBox(width: 6),
                          Text("You're offline — showing cached data"),
                        ],
                      ),
                    ),
                  ),

                /// 🔍 SEARCH RESULTS
                if (flashProvider.isSearching)

                  SliverPadding(

                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    sliver: SliverGrid(

                      delegate: SliverChildBuilderDelegate(

                        (context, index) {

                          final product =
                              flashProvider.searchResults[index];

                          return ProductCard(product: product);

                        },

                        childCount:
                            flashProvider.searchResults.length,

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

                  /// NORMAL CONTENT
                  const SliverToBoxAdapter(

                    child: Column(

                      children: [

                        BannerSection(imagePath: ''),
                        SizedBox(height: 15),

                        FlashSaleHeader(),

                        SizedBox(height: 30),

                        FeatureTabSection(),

                        SizedBox(height: 30),

                        PromoBox(
                          image: "assets/images/splash/promo1.jpeg",
                          title: "UPTO 30% OFF",
                        ),

                        SizedBox(height: 25),

                      ],

                    ),

                  ),

                  /// PRODUCT GRID
                  SliverPadding(

                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),

                    sliver: SliverGrid(

                      delegate: SliverChildBuilderDelegate(

                        (context, index) {

                          final product = homeProducts[index];

                          return ProductCard(product: product);

                        },

                        childCount:
                            homeProducts.length > 8
                                ? 8
                                : homeProducts.length,

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

                  const SliverToBoxAdapter(

                    child: Column(

                      children: [

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