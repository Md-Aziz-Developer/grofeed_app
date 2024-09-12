import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grofeed_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              brightness: Brightness.dark,
              primary: Color.fromRGBO(232, 99, 153, 1),
              secondary: Colors.white,
              background: const Color.fromRGBO(50, 51, 53, 1)),
          hoverColor: Colors.white),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
