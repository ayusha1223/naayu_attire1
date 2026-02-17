import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
import 'package:naayu_attire1/features/onboarding/presentation/screens/onboarding1.dart';
import 'package:naayu_attire1/features/onboarding/presentation/screens/onboarding2.dart';
import 'package:naayu_attire1/features/onboarding/presentation/screens/onboarding3.dart';

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});

  @override
  _OnboardingMainState createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PAGE VIEW
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: const [
              Onboarding1(),
              Onboarding2(),
              Onboarding3(),
            ],
          ),

          // SKIP BUTTON
         Positioned(
  top: 50,
  right: 20,
  child: GestureDetector(
    onTap: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(),
        ),
      );
    },
    child: const Text(
      "Skip",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
  ),
),


          // DOTS + NEXT/GET STARTED
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // DOTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: _currentPage == index ? 12 : 8,
                      height: _currentPage == index ? 12 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // NEXT / GET STARTED BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                 onPressed: () {
  if (_currentPage == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(),
      ),
    );
  } else {
    _controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
},
                  child: Text(
                    _currentPage == 2 ? "Get Started" : "Next",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}