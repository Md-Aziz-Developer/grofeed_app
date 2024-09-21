import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/dasboard_data_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DasboardScreen extends StatefulWidget {
  const DasboardScreen({super.key});

  @override
  State<DasboardScreen> createState() => _DasboardScreenState();
}

class _DasboardScreenState extends State<DasboardScreen> {
  bool _isDataLoading = true;
  String partnerId = '';
  DashboardData? dashboardData;
  List<Order> order = [];
  List<GraphData> graphData = [];
  String todayOrder = '0';
  String totalOrder = '0';
  String todayOrderAmount = '0';
  String totalOrderAmount = '0';
  String todayEarningAmount = '0';
  String totalEarningAmount = '0';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPartner();
  }

  void getPartner() async {
    final prefs = await SharedPreferences.getInstance();
    final partner = jsonDecode(prefs.getString('partner').toString());
    final id = partner['partner_id'];
    setState(() {
      partnerId = id;
    });
    getDashboardData();
  }

  void getDashboardData() async {
    final response = await http.post(Uri.parse(BASE_PATH + GET_DASHBOARD_DATA),
        body: {'partner_id': partnerId});
    if (response.statusCode == 200) {
      final myData = jsonDecode(response.body.toString());
      dashboardData = DashboardData.fromJson(myData);
      dashboardData!.order?.forEach((element) {
        order.add(element);
      });
      dashboardData!.graphData?.forEach((element) {
        graphData.add(element);
      });
      setState(() {
        todayOrder = dashboardData!.today!.orderCount.toString();
        totalOrder = dashboardData!.total!.orderCount.toString();
        todayOrderAmount = dashboardData!.today!.totalAmount.toString();
        todayOrderAmount = dashboardData!.total!.totalAmount.toString();
        todayEarningAmount = dashboardData!.today!.actualAmount.toString();
        totalEarningAmount = dashboardData!.total!.actualAmount.toString();
        _isDataLoading = false;
      });
    } else {
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  formatNumber(number) {
    return NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 0)
        .format(int.parse(number));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Image.asset(
            'assets/GROFEED_LOGO.png',
            height: 50,
          ),
          elevation: 3,
        ),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      const Text(
                        'Today Order',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatNumber(todayOrder),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      const Text(
                        'Total Order',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatNumber(totalOrder),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
