import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/wallet_list_model.dart';
import 'package:http/http.dart' as http;

class WalletController {
  Future<dynamic> getMyWallet(String partnerId, String from, String to) async {
    try {
      final response = await http.post(Uri.parse(BASE_PATH + GET_WALLET),
          body: {'partner_id': partnerId, "from": from, "to": to});
      dynamic resultdata;
      if (response.statusCode == 200) {
        resultdata =
            WalletDataList.fromJson(jsonDecode(response.body.toString()));
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
