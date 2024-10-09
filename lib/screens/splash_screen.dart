import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:grofeed_app/screens/login_screen.dart';
import 'package:grofeed_app/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(const Duration(seconds: 2), () {
    //   Get.offAll(() => const LoginScreen());
    // });
    checkPartner();
  }

  void checkPartner() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('partner_id')) {
      print(prefs.getString('partner_id').toString());
      final partnerId = jsonDecode(prefs.getString('partner_id').toString());
      final response = await http.post(
          Uri.parse(BASE_PATH + GET_LOGGED_IN_USER),
          body: {'partner_id': partnerId});
      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());

        if (myData['status'] == 1) {
          final partner = myData['partner'];
          final partnerId = myData['partner']['partner_id'];
          prefs.setString('partner_id', jsonEncode(partnerId));
          prefs.setString('partner', jsonEncode(partner));
          Get.offAll(() => const IndexScreen());
        } else {
          Get.offAll(() => const OnboardingScreen());
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAll(() => const OnboardingScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/splash_screen.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
