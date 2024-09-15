import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grofeed_app/widgets/product_container_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
      body: const Column(
        // mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'What would you like to Create Today?',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ProductContainerWidget(
                    backgroundColor: Color.fromRGBO(232, 99, 150, 1),
                    text: 'Host a Live Event',
                    icon: Icons.play_circle_outline,
                    screenPath: '/host_live_event'),
              ),
              Expanded(
                flex: 1,
                child: ProductContainerWidget(
                    backgroundColor: Color.fromRGBO(240, 74, 99, 1),
                    text: 'Locked Content',
                    icon: Icons.lock_outline,
                    screenPath: '/locked_content'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ProductContainerWidget(
                    backgroundColor: Color.fromRGBO(141, 110, 232, 1),
                    text: 'Payment Page',
                    icon: Icons.currency_rupee,
                    screenPath: '/payment_page'),
              ),
              Expanded(
                flex: 1,
                child: ProductContainerWidget(
                    backgroundColor: Color.fromRGBO(88, 138, 237, 1),
                    text: 'Telegram Channel',
                    icon: Icons.telegram_outlined,
                    screenPath: '/telegram'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ProductContainerWidget(
                    backgroundColor: Color.fromRGBO(232, 181, 86, 1),
                    text: 'Affliate Page',
                    icon: Icons.screen_search_desktop_rounded,
                    screenPath: '/affliate_page'),
              ),
              Expanded(
                flex: 1,
                child: ProductContainerWidget(
                    backgroundColor: Color.fromRGBO(201, 124, 153, 1),
                    text: 'Lauch Course',
                    icon: Icons.subject,
                    screenPath: '/launch_course'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
