import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/beneficiary_list_model.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ManageBeneficiary extends StatefulWidget {
  const ManageBeneficiary({super.key});

  @override
  State<ManageBeneficiary> createState() => _ManageBeneficiaryState();
}

class _ManageBeneficiaryState extends State<ManageBeneficiary> {
  bool _isDataLoading = true;
  String partnerId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPartner();
  }

  void getPartner() async {
    final prefs = await SharedPreferences.getInstance();
    final partner = jsonDecode(prefs.getString('partner').toString());
    // print(partner);
    final id = partner['partner_id'];
    // final name = partner['partner_name'];
    setState(() {
      partnerId = id;
      // partnerName = name;
    });
    getBeneficiaryList();
  }

  BeneficiaryList? beneficiaryList;
  List<Beneficiary> beneficiary = [];
  void getBeneficiaryList() async {
    final response = await http.post(
        Uri.parse(BASE_PATH + GET_BENEFICIARY_LIST),
        body: {'partner_id': partnerId});
    if (response.statusCode == 200) {
      beneficiaryList = BeneficiaryList.fromJson(
          response.body.toString() as Map<String, dynamic>);
      beneficiaryList!.beneficiary?.forEach((element) {
        beneficiary.add(element);
      });
      setState(() {
        _isDataLoading = false;
      });
      print(beneficiary);
    } else {
      setState(() {
        _isDataLoading = false;
      });
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
            leading: IconButton(
                onPressed: () {
                  Get.offAll(() => const IndexScreen(
                        initialIndex: 4,
                      ));
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                )),
            title: const Text(
              'My Beneficiary',
              style: TextStyle(color: Colors.white),
            ),
          )),
      body: _isDataLoading
          ? Center(child: CircularProgressIndicator())
          : Text('data'),
    );
  }
}
