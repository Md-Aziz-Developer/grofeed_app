import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/controllers/beneficiary_controller.dart';
import 'package:grofeed_app/screens/manage_beneficiary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBeneficiary extends StatefulWidget {
  const AddBeneficiary({super.key});

  @override
  State<AddBeneficiary> createState() => _AddBeneficiaryState();
}

class _AddBeneficiaryState extends State<AddBeneficiary> {
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
    final id = partner['partner_id'];
    setState(() {
      partnerId = id;
    });
  }

  final beneficiaryController = BeneficiaryController();
  bool _isLoading = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _bankname = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();
  TextEditingController _ifsccode = TextEditingController();

  void addBeneficiary() async {
    if (_name.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Name is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_name.text.toString().length < 3) {
      Get.snackbar('Ohh!!', 'Name is to short!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_bankname.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Email is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_accountNumber.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_accountNumber.text.toString().length < 9) {
      Get.snackbar('Ohh!!', 'Account Number to short',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_ifsccode.text.toString() == '') {
      Get.snackbar('Ohh!!', 'IFSC Coode is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_ifsccode.text.toString().length != 11) {
      Get.snackbar('Ohh!!', 'IFSC Code is valid!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isLoading = true;
      });
      final body = {
        'partner_id': partnerId,
        'name': _name.text.toString(),
        'bank_name': _bankname.text.toString(),
        'account_number': _accountNumber.text.toString(),
        'ifsc_code': _ifsccode.text.toString()
      };
      final response =
          await beneficiaryController.addBeneficiary(partnerId, body);
      if (response == 1) {
        Get.offAll(() => const ManageBeneficiary());
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
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
            leading: IconButton(
                onPressed: () {
                  Get.offAll(() => const ManageBeneficiary());
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                )),
            title: const Text(
              'Add Beneficiary',
              style: TextStyle(color: Colors.white),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: _name,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(Icons.abc_sharp),
                    border: InputBorder.none,
                    label: Text('Full Name'),
                    hintText: 'Enter Full Name'),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: _bankname,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_balance),
                    border: InputBorder.none,
                    label: Text('Bank Name'),
                    hintText: 'Enter Bank Name'),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: _accountNumber,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    icon: Icon(Icons.numbers),
                    border: InputBorder.none,
                    label: Text('Account Number'),
                    hintText: 'Enter Account Number'),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: _ifsccode,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(Icons.code),
                    border: InputBorder.none,
                    label: Text('IFSC Code '),
                    hintText: 'Enter IFSC Code'),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            _isLoading
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width * .5,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width * .5,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          addBeneficiary();
                        },
                        child: Text(
                          'Add Beneficiary',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
