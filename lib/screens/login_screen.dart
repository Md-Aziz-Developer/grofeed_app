import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/screens/otp_screen.dart';
import 'package:grofeed_app/screens/register_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  void sendOtp() async {
    if (number.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (number.text.toString().length != 10) {
      Get.snackbar('Ohh!!', 'Number nust be of 10 digit',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(Uri.parse(BASE_PATH + CHECK_NUMBER),
          body: {'number': number.text.toString()});
      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());

        if (myData['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          Get.snackbar('Ohh!!', myData['message'],
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAll(() => const OtpScreen(),
              arguments: ['login', number.text.toString()]);
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

  TextEditingController number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: Image.asset(
                'assets/GROFEED_LOGO.png',
                width: 250,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'NOW LAUNCH YOUR',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'OWN COMMUNITY APP',
                  style: TextStyle(
                      color: Color.fromRGBO(88, 138, 237, 1),
                      fontSize: 26,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Login Your Account Now',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: number,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    icon: Image.asset(
                      'assets/images/india.jpg',
                      width: 45,
                      height: 45,
                    ),
                    border: InputBorder.none,
                    hintText: 'Enter Mobile Number',
                    labelText: '+91'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Center(
              child: Container(
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
                      sendOtp();
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
                            'Sign In',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t Have Account ? ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offAll(() => const RegisterScreen());
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Color.fromRGBO(88, 138, 237, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Center(
                child: Text(
                    'By continuing you agree to our Terms & Privacy Policy')),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
