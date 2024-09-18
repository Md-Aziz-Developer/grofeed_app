import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ManageDocumentDetails extends StatefulWidget {
  const ManageDocumentDetails({super.key});

  @override
  State<ManageDocumentDetails> createState() => _ManageDocumentDetailsState();
}

class _ManageDocumentDetailsState extends State<ManageDocumentDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPartner();
  }

  String partnerId = '';
  String partnerName = '';
  String aadharDocFile = '';
  String panDocFile = '';
  bool _isLoading = false;
  bool _isAadharSelected = false;
  bool _isPANSelected = false;
  TextEditingController _aadhar_number = TextEditingController();
  TextEditingController _pan_number = TextEditingController();
  File? aadharDoc;
  Future getAadharDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        aadharDoc = File(result.files.single.path!);
        _isAadharSelected = true;
      });
    } else {
      setState(() {
        _isAadharSelected = false;
      });
    }
  }

  File? panDoc;
  Future getPanDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        panDoc = File(result.files.single.path!);
        _isPANSelected = true;
      });
    } else {
      setState(() {
        _isPANSelected = false;
      });
    }
  }

  void getPartner() async {
    final prefs = await SharedPreferences.getInstance();
    final partner = jsonDecode(prefs.getString('partner').toString());
    // print(partner);
    final id = partner['partner_id'];
    final name = partner['partner_name'];
    final partner_aadhar_number = partner['partner_aadhar_number'] ?? '';
    final partner_pan_number = partner['partner_pan_number'] ?? '';
    final partner_aadhar_docs = partner['partner_aadhar_docs'] ?? '';
    final partner_pan_docs = partner['partner_pan_docs'] ?? '';
    setState(() {
      partnerId = id;
      partnerName = name;
      _aadhar_number.text = partner_aadhar_number;
      _pan_number.text = partner_pan_number;
      aadharDocFile = partner_aadhar_docs;
      panDocFile = partner_pan_docs;

      if (partner_aadhar_docs != '') {
        _isAadharSelected = true;
      }
      if (partner_pan_docs != '') {
        _isPANSelected = true;
      }
    });
  }

  void updateDocumentsDetails() async {
    if (_aadhar_number.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Aadhar Number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_aadhar_number.text.toString().length != 12) {
      Get.snackbar('Ohh!!', 'Aadhar Number is not valid!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_pan_number.text.toString() == '') {
      Get.snackbar('Ohh!!', 'PAN Number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_pan_number.text.toString().length != 10) {
      Get.snackbar('Ohh!!', 'PAN Number is not valid!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (aadharDoc.toString() == '') {
      Get.snackbar('Ohh!!', 'Aadhar Copy is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (panDoc.toString() == '') {
      Get.snackbar('Ohh!!', 'PAN Copy is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isLoading = true;
      });
      var uri = Uri.parse(BASE_PATH + UPDATE_DOCUMENTS_DETAILS);
      var request = http.MultipartRequest('POST', uri);
      request.fields['partner_id'] = partnerId;
      request.fields['aadhar_number'] = _aadhar_number.text.toString();
      request.fields['pan_number'] = _pan_number.text.toString();
      aadharDoc != null
          ? request.files.add(http.MultipartFile.fromBytes(
              'aadhar_doc', File(aadharDoc!.path).readAsBytesSync(),
              filename: aadharDoc!.path))
          : 0;
      aadharDoc != null
          ? request.files.add(http.MultipartFile.fromBytes(
              'pan_doc', File(panDoc!.path).readAsBytesSync(),
              filename: panDoc!.path))
          : 0;
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        final myData = jsonDecode(responsed.body.toString());
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
        Get.snackbar('Ohhh!', 'Invalid Request!!!',
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
              '$partnerName Documents',
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
              'Manage Your Documents',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextFormField(
                      controller: _aadhar_number,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.file_copy),
                          border: InputBorder.none,
                          label: Text('Aadhar Number'),
                          hintText: 'Enter Aadhar Number'),
                      style: const TextStyle(),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: () {
                            getAadharDoc();
                          },
                          child: Icon(
                            Icons.document_scanner,
                            color:
                                _isAadharSelected ? Colors.green : Colors.white,
                          )))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextFormField(
                      controller: _pan_number,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.file_copy),
                          border: InputBorder.none,
                          label: Text('PAN Number'),
                          hintText: 'Enter PAN Number'),
                      style: const TextStyle(),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: () {
                            getPanDoc();
                          },
                          child: Icon(
                            Icons.document_scanner,
                            color: _isPANSelected ? Colors.green : Colors.white,
                          )))
                ],
              ),
            ),
            _isLoading
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width * .75,
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
                    width: MediaQuery.of(context).size.width * .75,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          updateDocumentsDetails();
                        },
                        child: Text(
                          'Update Document Details',
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
