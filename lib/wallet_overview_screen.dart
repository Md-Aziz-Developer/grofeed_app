import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/controllers/beneficiary_controller.dart';
import 'package:grofeed_app/models/beneficiary_list_model.dart';
import 'package:grofeed_app/screens/wallet_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletOverviewScreen extends StatefulWidget {
  const WalletOverviewScreen({super.key});

  @override
  State<WalletOverviewScreen> createState() => _WalletOverviewScreenState();
}

class _WalletOverviewScreenState extends State<WalletOverviewScreen> {
  bool _isDataLoading = true;
  bool _isBeneficaryLoaded = false;
  String partnerId = '';
  String totalAmount = '0.00';
  String availableAmount = '0.00';
  String requestedAmount = '0.00';
  String withdrawalAmount = '0.00';
  String disputeAmount = '0.00';
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
    getPartnerWallet();
  }

  void getPartnerWallet() async {
    try {
      final response = await http.post(
          Uri.parse(BASE_PATH + GET_PARTNER_WALLET),
          body: {'partner_id': partnerId});
      if (response.statusCode == 200) {
        var myData = jsonDecode(response.body.toString());
        if (myData['status'] == 1) {
          setState(() {
            totalAmount = myData['wallet']['total_wallet_amount'];
            availableAmount = myData['wallet']['total_available_amount'];
            requestedAmount = myData['wallet']['total_requested_amount'];
            withdrawalAmount = myData['wallet']['total_withdrawal_amount'];
            disputeAmount = myData['wallet']['total_dispute_amount'];
            _isDataLoading = false;
          });
          getBeneficiaryList();
        } else {
          setState(() {
            _isDataLoading = false;
          });
        }
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
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

  final beneficiaryController = BeneficiaryController();
  BeneficiaryList? beneficiaryList;
  List<Beneficiary> beneficiary = [];
  void getBeneficiaryList() async {
    final result = await beneficiaryController.getBeneficiaryList(partnerId);
    if (result != null) {
      beneficiary.clear();
      beneficiaryList = result;
      beneficiaryList!.beneficiary?.forEach((element) {
        beneficiary.add(element);
      });
      setState(() {
        _isBeneficaryLoaded = true;
      });
    } else {
      setState(() {
        _isBeneficaryLoaded = true;
      });
    }
  }

  TextEditingController _amount = TextEditingController();
  double enteredAmount = 0.00;
  String selectedBeneficiary = '';
  void enterAmount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Redemption'),
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.currency_rupee,
                    color: Theme.of(context).colorScheme.primary),
                border: InputBorder.none,
                labelText: 'Amount',
                hintText: 'Amount',
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child:
                  const Text('Proceed', style: TextStyle(color: Colors.green)),
              onPressed: () {
                proceedToSelectAccount();
              },
            ),
          ],
        );
      },
    );
  }

  void proceedToSelectAccount() async {
    if (_amount.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Amount is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (double.parse(_amount.text.toString()) < 1.00) {
      Get.snackbar('Ohh!!', 'Amount can\'t be less than 1!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (double.parse(_amount.text.toString()) >
        double.parse(availableAmount)) {
      Get.snackbar('Ohh!!', 'Amount can\'t exceed Available Amount!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        enteredAmount = double.parse(_amount.text.toString());
      });
      Navigator.of(context).pop();
      if (_isBeneficaryLoaded) {
        if (beneficiary.isEmpty) {
          Get.snackbar('Ohh!!', 'No Beneficary Account found!!!',
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          showBeneficiaryModel(context);
        }
      } else {
        final result =
            await beneficiaryController.getBeneficiaryList(partnerId);
        if (result != null) {
          beneficiary.clear();
          beneficiaryList = result;
          beneficiaryList!.beneficiary?.forEach((element) {
            beneficiary.add(element);
          });
          setState(() {
            _isBeneficaryLoaded = true;
          });
          showBeneficiaryModel(context);
        } else {
          Get.snackbar('Ohh!!', 'No Beneficary Account found!!!',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    }
  }

  void showBeneficiaryModel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * .45,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: beneficiary.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 3);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white54),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(beneficiary[index].bankName.toString()),
                            Text(' (${beneficiary[index].ifscCode}) ')
                          ],
                        ),
                        subtitle: Text(
                            'Account Number: ${beneficiary[index].accountNumber}'),
                        onTap: () {
                          redeemNow(beneficiary[index].benificeryId.toString());
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void redeemNow(String beneficaryId) async {
    if (beneficaryId == '') {
      Get.snackbar('Ohh!!', 'Select Beneficary Account to Proceed!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      try {
        final response =
            await http.post(Uri.parse(BASE_PATH + REQUEST_REDEEM), body: {
          'partner_id': partnerId,
          "amount": _amount.text.toString(),
          "ben_id": beneficaryId
        });
        if (response.statusCode == 200) {
          var myData = jsonDecode(response.body.toString());
          if (myData['status'] == 1) {
            setState(() {
              _isDataLoading = true;
              enteredAmount = 0.00;
              selectedBeneficiary = '';
              _amount.text = '';
            });
            Get.snackbar('Hurry!!', myData['message'],
                backgroundColor: Colors.green, colorText: Colors.white);
            getPartnerWallet();
          } else {
            setState(() {
              _isDataLoading = false;
              enteredAmount = 0.00;
              selectedBeneficiary = '';
              _amount.text = '';
            });
            Get.snackbar('Ohh!!', myData['message'],
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          setState(() {
            _isDataLoading = false;
            enteredAmount = 0.00;
            selectedBeneficiary = '';
            _amount.text = '';
          });
          Get.snackbar('Ohh!!', "Bad Request",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        setState(() {
          _isDataLoading = false;
          enteredAmount = 0.00;
          selectedBeneficiary = '';
          _amount.text = '';
        });
      }
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
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => const WalletScreen());
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      body: _isDataLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Once you redeem it, the credit will be processed within 24 hours',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .42,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(106, 140, 107, 1),
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        margin: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            const Text(
                              'Total \r\nAmount',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatNumber(totalAmount),
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
                      Container(
                        width: MediaQuery.of(context).size.width * .42,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(106, 140, 107, 1),
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        margin: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            const Text(
                              'Available\r\n Amount',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatNumber(availableAmount),
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
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .42,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(106, 140, 107, 1),
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        margin: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            const Text(
                              'Requested\r\n Amount',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatNumber(requestedAmount.toString()),
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
                      Container(
                        width: MediaQuery.of(context).size.width * .42,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(106, 140, 107, 1),
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        margin: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            const Text(
                              'Withdrawal \r\nAmount',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatNumber(withdrawalAmount.toString()),
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
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .47,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(201, 124, 153, 1),
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        margin: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            const Text(
                              'Dispute\r\n Amount',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatNumber(disputeAmount.toString()),
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                double.parse(availableAmount) < 1.00
                    ? const SizedBox()
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          enterAmount(context);
                        },
                        icon: const Icon(Icons.currency_rupee_outlined),
                        label: const Text(
                          'Request Redemption',
                          style: TextStyle(fontSize: 20),
                        ))
              ]),
            ),
    );
  }
}
