import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  String partnerName = '';
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
    final name = partner['partner_name'];
    final email = partner['partner_email'];
    final number = partner['partner_number'];
    final username = partner['partner_username'];
    final address = partner['partner_address'] ?? '';
    setState(() {
      partnerId = id;
      partnerName = name;
      _name.text = name;
      _email.text = email;
      _number.text = number;
      _username.text = username;
      _address.text = address;
    });
  }

  bool _isLoading = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _address = TextEditingController();
  bool isEmailValid(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool validateUsername(String username) {
    final RegExp allowedChars = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_]*$');
    return allowedChars.hasMatch(username);
  }

  void updateProfile() async {
    if (_name.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Name is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_name.text.toString().length < 3) {
      Get.snackbar('Ohh!!', 'Name is to short!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_email.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Email is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (!isEmailValid(_email.text.toString())) {
      Get.snackbar('Ohh!!', 'Email is not valid',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_number.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_number.text.toString().length != 10) {
      Get.snackbar('Ohh!!', 'Number nust be of 10 digit',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_username.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Username is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_username.text.toString().length < 6) {
      Get.snackbar('Ohh!!', 'Username is to short!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_username.text.toString().length > 20) {
      Get.snackbar('Ohh!!', 'Username is to long!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (!validateUsername(_username.text.toString())) {
      Get.snackbar('Ohh!!', 'Username is not valid',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_address.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Address is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isLoading = true;
      });
      final response =
          await http.post(Uri.parse(BASE_PATH + UPDATE_PROFILE), body: {
        'partner_id': partnerId,
        'name': _name.text.toString(),
        'email': _email.text.toString(),
        'number': _number.text.toString(),
        'user_name': _username.text.toString(),
        'address': _address.text.toString()
      });
      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());
        if (myData['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          final partner = myData['partner'];
          // print(partner);
          final partnerId = myData['partner']['partner_id'];
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('partner_id', jsonEncode(partnerId));
          prefs.setString('partner', jsonEncode(partner));
          getPartner();
          Get.snackbar('Hurry', myData['message'],
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          setState(() {
            _isLoading = false;
          });
          Get.snackbar('Ohh!!', myData['message'],
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar('Ohh!!', 'Bad Request Try Again!!!',
            backgroundColor: Colors.red, colorText: Colors.white);
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
                  Get.offAll(() => const IndexScreen(
                        initialIndex: 4,
                      ));
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                )),
            title: Text(
              '$partnerName profile',
              style: const TextStyle(color: Colors.white),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Text(
              'Manage Your Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
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
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Name is required!!!";
                  } else if (value!.length < 3) {
                    return 'Name is to short!!!';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    border: InputBorder.none,
                    label: Text('Your Email'),
                    hintText: 'Enter Your Email'),
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
                controller: _number,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    icon: Icon(Icons.numbers),
                    border: InputBorder.none,
                    label: Text('Mobile Number'),
                    hintText: '+91'),
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
                controller: _username,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(Icons.abc_sharp),
                    border: InputBorder.none,
                    label: Text('Username '),
                    hintText: 'Enter your username'),
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
                controller: _address,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(Icons.abc_sharp),
                    border: InputBorder.none,
                    label: Text('Address '),
                    hintText: 'Enter your address'),
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
                          updateProfile();
                        },
                        child: Text(
                          'Update Profile',
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
