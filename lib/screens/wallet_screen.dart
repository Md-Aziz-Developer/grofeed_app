import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/controllers/wallet_controller.dart';
import 'package:grofeed_app/models/wallet_list_model.dart';
import 'package:grofeed_app/screens/index_screen.dart';
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
  List walletSelected = [];
  List walletCanSelect = [];
  List walletAmount = [];
  List<bool> _selectedList = [];
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
    getMyWallet();
  }

  void getMyWallet() async {
    String from = fromDate.toString();
    String to = toDate.toString();
    final result = await walletController.getMyWallet(partnerId, from, to);
    if (result != null) {
      wallet.clear();

      walletDataList = result;
      walletDataList!.wallet?.forEach((element) {
        wallet.add(element);
        // if (element.withdrawalStatus != 'success' &&
        //     element.withdrawalStatus != 'dispute') {
        //   walletSelected.add(false);
        //   walletCanSelect.add(element.walletCreditId);
        //   walletAmount.add(element.actualAmount);
        // }
        _selectedList.add(false);
      });
    }
    setState(() {
      _isDataLoading = false;
    });
  }

  void _handleCardSelection(int index, bool isSelected) {}

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
          leading: IconButton(
              onPressed: () {
                Get.offAll(() => const IndexScreen(
                      initialIndex: 3,
                    ));
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              )),
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
                      label: Text(DateFormat('dd-MM-yyyy').format(fromDate),
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
                        getMyWallet();
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
                : wallet.length == 0
                    ? const Text('No Wallet Found!!!')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: wallet.length,
                        itemBuilder: (context, index) {
                          return WalletCard(
                              orderNumber: wallet[index].orderNumber.toString(),
                              creditDate: wallet[index].creditDate.toString(),
                              collectedAmount:
                                  wallet[index].collectedAmount.toString(),
                              actualAmount:
                                  wallet[index].actualAmount.toString(),
                              commissionAmount:
                                  wallet[index].commissionAmount.toString(),
                              withdrawalStatus:
                                  wallet[index].withdrawalStatus.toString(),
                              isSelected: _selectedList[index],
                              onSelectCard: (isSelected) =>
                                  _handleCardSelection(index, isSelected));
                        },
                      )
          ],
        ),
      ),
    );
  }
}
