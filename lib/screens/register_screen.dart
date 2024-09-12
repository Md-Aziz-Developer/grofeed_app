import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/screens/login_screen.dart';
import 'package:grofeed_app/screens/otp_screen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  bool isChecked = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _username = TextEditingController();
  bool isEmailValid(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool validateUsername(String username) {
    final RegExp allowedChars = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_]*$');
    return allowedChars.hasMatch(username);
  }

  String _selectedItems = '';
  final List<String> _items = [
    'Build an online Course',
    'Launch a course',
    'Offer 1 on 1 Session',
    'Host events & Webinars',
    'Start paid telegram community',
    'Sell digital products',
  ];
  void signUp() async {
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
    } else if (_selectedItems == '') {
      Get.snackbar('Ohh!!', 'Goal is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (!isChecked) {
      Get.snackbar('Ohh!!', 'Check the checkbox!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(Uri.parse(BASE_PATH + REGISTER), body: {
        'name': _name.text.toString(),
        'email': _email.text.toString(),
        'number': _number.text.toString(),
        'username': _username.text.toString(),
        'goal': _selectedItems.toString()
      });
      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());
        if (myData['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          Get.offAll(() => const OtpScreen(),
              arguments: ['register', _number.text.toString()]);
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Image.asset(
                'assets/GROFEED_LOGO.png',
                width: 150,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                'Share some information about yourself.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
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
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Email Id is required!!!";
                  } else if (!isEmailValid(value!)) {
                    return "Email Id is not valid!!!";
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
                controller: _number,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    icon: Icon(Icons.numbers),
                    border: InputBorder.none,
                    label: Text('Mobile Number'),
                    hintText: '+91'),
                style: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Number is required!!!";
                  } else if (value!.length != 10) {
                    return 'Number must be of 10 digit!!!';
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
                controller: _username,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(Icons.abc_sharp),
                    border: InputBorder.none,
                    label: Text('Username '),
                    hintText: 'Enter your username'),
                style: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Username is required!!!";
                  } else if (value!.length < 6) {
                    return 'Username is to short!!!';
                  } else if (value.length > 20) {
                    return 'Username is to long!!!';
                  } else if (!validateUsername(value)) {
                    return 'Username is not valid!!!';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 3),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: DropdownButtonFormField<String>(
                value: _selectedItems.isNotEmpty ? _selectedItems : null,
                items: _items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedItems = value!;
                  });
                },
                isExpanded: true,
                hint: const Text('Select your options'),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.check_box_outline_blank_sharp),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      checkColor: Colors.black,
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked = newValue ?? false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                      flex: 9,
                      child: Container(
                        child: const Text(
                            'By Proceeding, you agree the terms and conditions and the privacy policy '),
                      ))
                ],
              ),
            ),
            Container(
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
                    signUp();
                  },
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      : Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        )),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already Have Account ? ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offAll(() => const LoginScreen());
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                        color: Color.fromRGBO(88, 138, 237, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
