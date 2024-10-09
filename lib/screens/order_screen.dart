import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/order_list_model.dart';
import 'package:grofeed_app/widgets/order_card_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isDataLoading = true;
  String partnerId = '';
  OrderList? orderList;
  List<Order> order = [];
  var fromDate = DateTime.now();
  var toDate = DateTime.now();

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
    getMyOrders();
  }

  void getMyOrders() async {
    String from = fromDate.toString();
    String to = toDate.toString();
    try {
      final response = await http.post(Uri.parse(BASE_PATH + GET_ORDER),
          body: {'partner_id': partnerId, "from": from, "to": to});
      dynamic resultdata;
      if (response.statusCode == 200) {
        resultdata = OrderList.fromJson(jsonDecode(response.body.toString()));
        if (resultdata != null) {
          order.clear();

          orderList = resultdata;
          orderList!.order?.forEach((element) {
            order.add(element);
          });
          setState(() {
            _isDataLoading = false;
          });
        } else {
          setState(() {
            _isDataLoading = false;
          });
        }
      } else {
        setState(() {
          _isDataLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? fromDatePicked = await showDatePicker(
                          context: context,
                          initialDate: fromDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: Colors.black,
                                ),

                                dialogBackgroundColor:
                                    Colors.white, // Dialog background
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (fromDatePicked != null) {
                          setState(() {
                            fromDate = fromDatePicked;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                      label: Text(
                          '${DateFormat('dd-MM-yyyy').format(fromDate)}',
                          style: const TextStyle(color: Colors.white))),
                  ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? toDatePicked = await showDatePicker(
                          context: context,
                          initialDate: toDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: Colors.black,
                                ),

                                dialogBackgroundColor:
                                    Colors.white, // Dialog background
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (toDatePicked != null) {
                          setState(() {
                            toDate = toDatePicked;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                      label: Text(
                        '${DateFormat('dd-MM-yyyy').format(toDate)}',
                        style: const TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isDataLoading = true;
                        getMyOrders();
                      });
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              height: 10,
            ),
            _isDataLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : order.length == 0
                    ? const Text('No Order Found!!!')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.length,
                        itemBuilder: (context, index) {
                          return OrderCardWidget(
                              orderNumber: order[index].orderNumber.toString(),
                              userName: order[index].userName.toString(),
                              orderDate: order[index].orderDate.toString(),
                              orderStatus: order[index].orderStatus.toString(),
                              contentType: order[index].contentType.toString(),
                              contentTitle: order[index].title.toString(),
                              orderAmount: formatNumber(
                                  order[index].orderAmount.toString()),
                              paymentId:
                                  order[index].orderPaymentId.toString());
                        },
                      )
          ],
        ),
      ),
    );
  }
}
