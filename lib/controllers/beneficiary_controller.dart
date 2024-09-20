import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/beneficiary_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryController {
  Future<dynamic> getBeneficiaryList(String partnerId) async {
    try {
      final response = await http.post(
          Uri.parse(BASE_PATH + GET_BENEFICIARY_LIST),
          body: {'partner_id': partnerId});
      dynamic resultdata;
      if (response.statusCode == 200) {
        resultdata =
            BeneficiaryList.fromJson(jsonDecode(response.body.toString()));
      } else {
        resultdata = null;
      }
      return resultdata;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<int> addBeneficiary(String partnerId, dynamic body) async {
    try {
      final response =
          await http.post(Uri.parse(BASE_PATH + ADD_BENEFICIARY), body: body);
      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());
        if (myData['status'] == 1) {
          final partner = myData['partner'];
          // print(partner);
          final partnerId = myData['partner']['partner_id'];
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('partner_id', jsonEncode(partnerId));
          prefs.setString('partner', jsonEncode(partner));
          Get.snackbar('Hurry', myData['message'],
              backgroundColor: Colors.green, colorText: Colors.white);
          return 1;
        } else {
          Get.snackbar('Ohh!!', myData['message'],
              backgroundColor: Colors.red, colorText: Colors.white);
          return 0;
        }
      } else {
        Get.snackbar('Ohh!!', 'Bad Request Try Again',
            backgroundColor: Colors.red, colorText: Colors.white);
        return 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return 0;
    }
  }
}
