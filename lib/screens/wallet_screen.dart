import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grofeed_app/controllers/wallet_controller.dart';
import 'package:grofeed_app/models/wallet_list_model.dart';
import 'package:grofeed_app/widgets/wallet_card_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isDataLoading = true;
  String partnerId = '';
  final walletController = WalletController();
  WalletDataList? walletDataList;
  List<Wallet> wallet = [];
  var fromDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 7);
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
    getMyWallet();
  }

  void getMyWallet() async {
    print('kkk');
    String from = fromDate.toString();
    String to = toDate.toString();
    final result = await walletController.getMyWallet(partnerId, from, to);
    if (result != null) {
      wallet.clear();

      walletDataList = result;
      walletDataList!.wallet?.forEach((element) {
        wallet.add(element);
      });
    }
    setState(() {
      _isDataLoading = false;
    });
  }

  void _handleCardSelection(bool selected) {
    setState(() {
      // _isSelected = selected;
    });
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? fromDatePicked = await showDatePicker(
                            context: context,
                            initialDate: fromDate,
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now());
                        if (fromDatePicked != null) {
                          setState(() {
                            fromDate = fromDatePicked;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                      label: Text(
                          '${DateFormat('dd-MM-yyyy').format(fromDate)}',
                          style: TextStyle(color: Colors.white))),
                  ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? toDatePicked = await showDatePicker(
                            context: context,
                            initialDate: toDate,
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now());
                        if (toDatePicked != null) {
                          setState(() {
                            toDate = toDatePicked;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                      label: Text(
                        '${DateFormat('dd-MM-yyyy').format(toDate)}',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isDataLoading = true;
                        getMyWallet();
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: wallet.length,
              itemBuilder: (context, index) {
                return WalletCard(
                    orderNumber: wallet[index].orderNumber.toString(),
                    creditDate: wallet[index].creditDate.toString(),
                    collectedAmount: wallet[index].collectedAmount.toString(),
                    actualAmount: wallet[index].actualAmount.toString(),
                    commissionAmount: wallet[index].commissionAmount.toString(),
                    withdrawalStatus: wallet[index].withdrawalStatus.toString(),
                    isSelected: false,
                    onSelectCard: _handleCardSelection);
              },
            )
          ],
        ),
      ),
    );
  }
}
