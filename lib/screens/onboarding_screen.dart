import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/screens/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              buildPage(
                title: 'Welcome!',
                description: 'This is the first intro screen.',
                imagePath: 'assets/images/WELCOME_PAGE_IMAGE_1.png',
                color: Colors.blueAccent,
              ),
              buildPage(
                title: 'Discover!',
                description: 'This is the second intro screen.',
                imagePath: 'assets/images/WELCOME_PAGE_IMAGE_2.png',
                color: Colors.greenAccent,
              ),
              buildPage(
                title: 'Get Started!',
                description: 'This is the third intro screen.',
                imagePath: 'assets/images/WELCOME_PAGE_IMAGE_3.png',
                color: Colors.orangeAccent,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController, // Page controller
                  count: 3, // Number of pages
                  effect: const WormEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(const LoginScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Widget to build each intro page
  Widget buildPage({
    required String title,
    required String description,
    required String imagePath,
    required Color color,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            scale: 1,
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
          ), // Use your own images here
        ],
      ),
    );
  }
}
