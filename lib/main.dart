import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grofeed_app/screens/host_live_event.dart';
import 'package:grofeed_app/screens/locked_content_screen.dart';
import 'package:grofeed_app/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final List<GetPage> _pages = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/host_live_event', page: () => HostLiveEvent()),
    GetPage(name: '/locked_content', page: () => LockedContentScreen())
  ];
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
      initialRoute: '/',
      getPages: _pages,
    );
  }
}
