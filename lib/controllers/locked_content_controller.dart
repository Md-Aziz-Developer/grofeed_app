import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/models/locked_content_list_model.dart';
import 'package:http/http.dart' as http;

class LockedContentController {
  Future<dynamic> getLockedContentList(String partnerId) async {
    try {
      final response = await http.post(
          Uri.parse(BASE_PATH + GET_LOCKED_CONTENT_LIST),
          body: {'partner_id': partnerId});
      dynamic resultdata;
      if (response.statusCode == 200) {
        resultdata =
            LockedContentList.fromJson(jsonDecode(response.body.toString()));
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

  Future<dynamic> getLockedContentById(
      String partnerId, String contentId) async {
    try {
      final response = await http.post(
          Uri.parse(BASE_PATH + GET_LOCKED_CONTENT_BY_ID),
          body: {'partner_id': partnerId, 'content_id': contentId});
      dynamic resultdata;
      if (response.statusCode == 200) {
        resultdata =
            LockedContentList.fromJson(jsonDecode(response.body.toString()));
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

  Future<int> addLockedContent(
      Map<String, dynamic> formData, List<PlatformFile>? files) async {
    var uri = Uri.parse(BASE_PATH + ADD_LOCKED_CONTENT);
    var request = http.MultipartRequest('POST', uri);

    // Add form fields
    formData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add files to the request (if any)
    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        // Assuming files are being picked from local storage, use File
        request.files.add(
          await http.MultipartFile.fromPath(
            'locked_content[]', // Use the correct field name for the files
            file.path!,
            filename: file.name,
          ),
        );
      }
    }
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());
        if (myData['status'] == 1) {
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

  Future<int> editLockedContent(
      Map<String, dynamic> formData, List<PlatformFile>? files) async {
    var uri = Uri.parse(BASE_PATH + EDIT_LOCKED_CONTENT);
    var request = http.MultipartRequest('POST', uri);

    // Add form fields
    formData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add files to the request (if any)
    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        // Assuming files are being picked from local storage, use File
        request.files.add(
          await http.MultipartFile.fromPath(
            'locked_content[]', // Use the correct field name for the files
            file.path!,
            filename: file.name,
          ),
        );
      }
    }
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());
        if (myData['status'] == 1) {
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

  Future<int> deleteLockedContent(String partnerId, String contentId) async {
    try {
      final response = await http.post(
          Uri.parse(BASE_PATH + DELETE_LOCKED_CONTENT),
          body: {'partner_id': partnerId, 'content_id': contentId});
      if (response.statusCode == 200) {
        final myData = jsonDecode(response.body.toString());
        if (myData['status'] == 1) {
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
