import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/controllers/beneficiary_controller.dart';
import 'package:grofeed_app/models/beneficiary_list_model.dart';
import 'package:grofeed_app/screens/add_beneficiary.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageBeneficiary extends StatefulWidget {
  const ManageBeneficiary({super.key});

  @override
  State<ManageBeneficiary> createState() => _ManageBeneficiaryState();
}

class _ManageBeneficiaryState extends State<ManageBeneficiary> {
  bool _isDataLoading = true;
  String partnerId = '';
  final beneficiaryController = BeneficiaryController();
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
    final result = await beneficiaryController.getBeneficiaryList(partnerId);
    if (result != null) {
      beneficiaryList = result;
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(height: 5);
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: beneficiary.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white54)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(beneficiary[index].bankName.toString()),
                          Text(' (${beneficiary[index].ifscCode}) ')
                        ],
                      ),
                      subtitle: Text(
                          'Account Number : ${beneficiary[index].accountNumber}'),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddBeneficiary());
        },
        tooltip: 'Add',
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 40,
        ),
      ),
    );
  }
}
