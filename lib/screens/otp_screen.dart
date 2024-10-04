import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:grofeed_app/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _isLoading = false;
  int number = 9354367704;
  String type = '';

  // Controllers for each OTP box
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    setState(() {
      type = Get.arguments[0];
      number = int.parse(Get.arguments[1]);
    });
  }

  void verifyOtp() async {
    String otp = otpControllers.map((controller) => controller.text).join();

    if (otp.isEmpty) {
      Get.snackbar('Ohh!!', 'OTP is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (otp.length != 6) {
      Get.snackbar('Ohh!!', 'OTP must be of 6 digits',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(Uri.parse(BASE_PATH + VERIFY_OTP),
          body: {'number': number.toString(), 'otp': otp, "type": type});
      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());

        if (myData['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          final partner = myData['partner'];
          final partnerId = myData['partner']['partner_id'];
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('partner_id', jsonEncode(partnerId));
          prefs.setString('partner', jsonEncode(partner));
          Get.offAll(() => const IndexScreen());
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

  void resendOtp() async {
    final response = await http.post(Uri.parse(BASE_PATH + RESEND_OTP),
        body: {'number': number.toString()});
    if (response.statusCode == 200) {
      final myData = jsonDecode(response.body.toString());

      if (myData['status'] == 1) {
        Get.snackbar('Ohh!!', myData['message'],
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Ohh!!', myData['message'],
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Ohh!!', 'Bad Request Try Again!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/GROFEED_LOGO.png',
                width: 250,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            const Text(
              'Verify Your Number',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            type == 'login'
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      children: [
                        Text('+91 ${number.toString()} '),
                        GestureDetector(
                            onTap: () {
                              Get.offAll(() => LoginScreen());
                            },
                            child: const Text(
                              'Change Number',
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            // OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: otpControllers[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        counterText: "",
                      ),
                      onChanged: (value) {
                        // Move to next field if current field is filled
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        // Move to previous field if empty
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width * .5,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    verifyOtp();
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
                          'Verify OTP',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        )),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                resendOtp();
              },
              child: const Text(
                'Resend OTP',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
