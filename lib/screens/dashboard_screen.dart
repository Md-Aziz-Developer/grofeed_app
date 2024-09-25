import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/dasboard_data_model.dart';
import 'package:grofeed_app/widgets/order_card_widget.dart';
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
      // print(todayEarningAmount);
      // print(totalEarningAmount);
      // // Convert order amounts to double
      // List<BarChartGroupData> barChartData =
      //     graphData.asMap().entries.map((entry) {
      //   int index = entry.key;
      //   var data = entry.value;
      //   // print(data.)
      //   return BarChartGroupData(
      //     x: index,
      //     barRods: [
      //       BarChartRodData(
      //         toY: double.parse(data.orderAmount.toString()),
      //         width: 16,
      //         color: Colors.blue,
      //       ),
      //     ],
      //   );
      // }).toList();
    } else {
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  formatNumber(number) {
    try {
      return NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
          .format(double.parse(number));
    } catch (e) {
      return number;
    }
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
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            // padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(66, 66, 66, 1),
                      border: Border.all(width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
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
                              todayOrder,
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
                      color: Color.fromRGBO(66, 66, 66, 1),
                      border: Border.all(width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
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
                              totalOrder,
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
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(66, 66, 66, 1),
                      border: Border.all(width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    margin: const EdgeInsets.all(3),
                    child: Column(
                      children: [
                        const Text(
                          'Today Amount',
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
                              formatNumber(todayEarningAmount.toString()),
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
                      color: Color.fromRGBO(66, 66, 66, 1),
                      border: Border.all(width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    margin: const EdgeInsets.all(3),
                    child: Column(
                      children: [
                        const Text(
                          'Total Amount',
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
                              formatNumber(totalEarningAmount.toString()),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Last 5 Orders',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListView.builder(
            // scrollDirection: Axis.vertical,
            // physics: ,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: order.length,
            itemBuilder: (context, index) {
              return OrderCardWidget(
                  orderNumber: order[index].orderNumber.toString(),
                  userName: order[index].userName.toString(),
                  orderDate: order[index].orderDate.toString(),
                  orderStatus: order[index].orderStatus.toString(),
                  contentType: order[index].contentType.toString(),
                  contentTitle: order[index].title.toString(),
                  orderAmount:
                      formatNumber(order[index].orderAmount.toString()),
                  paymentId: order[index].orderPaymentId.toString());
            },
          )
        ]),
      ),
    );
  }
}
