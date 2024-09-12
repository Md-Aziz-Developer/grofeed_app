import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
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
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            elevation: 3,
            title: Text(
              'Welcome ' + partnerName,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Get.offAll(() => LoginScreen());
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )),
      body: Center(
        child: Text('Hii there ' + partnerName),
      ),
    );
  }
}
