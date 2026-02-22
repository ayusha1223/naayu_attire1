import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

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
            children: [

              const Text(
                "Report a Technical Problem",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "We detected unusual device movement. "
                "If you're experiencing any technical issue, "
                "please report it to our support team.",
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7c5cff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Problem reported successfully."),
                      ),
                    );
                  },
                  child: const Text(
                    "REPORT PROBLEM",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
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
              SizedBox(height: 30),

              FlashSaleHeader(),
              SizedBox(height: 20),
            
              PromoBox(
                image: "assets/images/splash/promo1.jpeg",
                title: "UPTO 30% OFF",
              ),

              SizedBox(height: 25),

              BestSellingSection(),

              SizedBox(height: 25),

              PromoBox(
                image: "assets/images/splash/promo2.jpeg",
                title: "FLAT 16% OFF",
              ),

              SizedBox(height: 30),

              ServiceFooterSection()
            ],
          ),
        ),
      ),
    );
  }
}