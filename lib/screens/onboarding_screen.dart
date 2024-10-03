import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/screens/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome To Grofeed",
          body: 'Grofeed',
          image: Image.asset(
            'assets/images/WELCOME_PAGE_IMAGE_1.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Welcome To Grofeed",
          body: 'Grofeed',
          image: Image.asset(
            'assets/images/WELCOME_PAGE_IMAGE_2.png',
            width: MediaQuery.of(context).size.width * .90,
            height: MediaQuery.of(context).size.height * .90,
            fit: BoxFit.cover,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Welcome To Grofeed",
          body: 'Grofeed',
          image: Center(
            child: Image.asset(
              'assets/images/WELCOME_PAGE_IMAGE_3.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text(
        'Done',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      onDone: () {
        Get.offAll(() => LoginScreen());
      },
      showSkipButton: true,
      skip: Text(
        'Skip',
        style: TextStyle(color: Colors.white),
      ),
      onSkip: () {
        Get.off(() => LoginScreen());
      },
      next: Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      dotsDecorator: getDotDecoration(),
    ));
  }

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        activeColor: Color.fromRGBO(232, 99, 153, 1),
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );
  PageDecoration getPageDecoration() => PageDecoration(
      imageFlex: 100,
      titlePadding: EdgeInsets.zero,
      imagePadding: EdgeInsets.zero,
      footerPadding: EdgeInsets.zero,
      bodyPadding: EdgeInsets.zero);
}
