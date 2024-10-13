import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grofeed_app/screens/dashboard_screen.dart';
import 'package:grofeed_app/screens/order_screen.dart';
import 'package:grofeed_app/screens/products_screen.dart';
import 'package:grofeed_app/screens/setting_screen.dart';
import 'package:grofeed_app/screens/wallet_screen.dart';
import 'package:grofeed_app/wallet_overview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexScreen extends StatefulWidget {
  final int? initialIndex;
  const IndexScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  String partnerName = '';
  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = widget.initialIndex ?? 0;
    });
    getPartner();
  }

  final List<Widget> _pages = [
    const DasboardScreen(),
    const OrderScreen(),
    const ProductScreen(),
    const WalletOverviewScreen(),
    const SettingScreen()
  ];

  void getPartner() async {
    final prefs = await SharedPreferences.getInstance();
    final partner = jsonDecode(prefs.getString('partner').toString());
    final name = partner['partner_name'];
    setState(() {
      partnerName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 20,
          unselectedFontSize: 18,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined), label: 'Order'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: 'Create'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.wallet_rounded), label: 'Wallet'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Setting'),
          ],
        ),
      ),
    );
  }
}
