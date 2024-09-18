import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/beneficiary_list_model.dart';
import 'package:http/http.dart' as http;

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
}
