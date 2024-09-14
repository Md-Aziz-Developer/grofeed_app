import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String partnerName = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPartner();
  }

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.black,
          title: Image.asset(
            'assets/GROFEED_LOGO.png',
            height: 50,
          ),
          elevation: 3,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/image.png',
              height: 100,
            ),
          ),
          Text('Hii ' + partnerName)
        ],
      ),
    );
  }
}
