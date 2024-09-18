import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/constants/api_path.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ManageBusinessDetails extends StatefulWidget {
  const ManageBusinessDetails({super.key});

  @override
  State<ManageBusinessDetails> createState() => _ManageBusinessDetailsState();
}

class _ManageBusinessDetailsState extends State<ManageBusinessDetails> {
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
    final name = partner['partner_business_name'];
    final email = partner['partner_business_email'];
    final number = partner['partner_business_number'];
    final address = partner['partner_business_address'];
    final category = partner['partner_business_category'];
    final logo = partner['partner_business_logo'];
    setState(() {
      partnerId = id;
      partnerName = name;
      _name.text = name;
      _email.text = email;
      _number.text = number;
      _address.text = address;
      _selectedItems = category;
      currentImage = logo;
    });
  }

  bool _isLoading = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _address = TextEditingController();
  String _selectedItems = '';
  String currentImage = '';
  final List<String> _items = [
    'Finance',
    'Education',
    'Food',
    'Job',
    'Entertainment',
    'Travel',
    'Marketing',
    'Fitness',
    'Other'
  ];
  // File? image;
  // final _picker = ImagePicker();
  // Future getImage() async {
  //   final pickedFile =
  //       await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
  //   if (pickedFile != null) {
  //     setState(() {
  //       currentImage = '';
  //       image = File(pickedFile.path);
  //     });
  //   } else {
  //     print('No image selected');
  //   }
  // }
  File? file;
  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        currentImage = ''; // if you still want to reset it
        file = File(result.files.single.path!);
      });
    } else {
      print('No file selected');
    }
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  void updateBusinessDetails() async {
    if (_name.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Name is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_name.text.toString().length < 3) {
      Get.snackbar('Ohh!!', 'Name is to short!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_email.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Email is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    // else if (!isEmailValid(_email.text.toString())) {
    //   Get.snackbar('Ohh!!', 'Email is not valid',
    //       backgroundColor: Colors.red, colorText: Colors.white);
    // }
    else if (_number.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    //  else if (_number.text.toString().length != 10) {
    //   Get.snackbar('Ohh!!', 'Number nust be of 10 digit',
    //       backgroundColor: Colors.red, colorText: Colors.white);
    // }
    else if (_address.text.toString() == '') {
      Get.snackbar('Ohh!!', 'Address is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (_selectedItems.toString() == '') {
      Get.snackbar('Ohh!!', 'Business Category is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (image.toString() == '') {
      Get.snackbar('Ohh!!', 'Business Logo is required!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isLoading = true;
      });

      var uri = Uri.parse(BASE_PATH + UPDATE_BUSINESS_DETAILS);
      var request = http.MultipartRequest('POST', uri);
      request.fields['partner_id'] = partnerId;
      request.fields['name'] = _name.text.toString();
      request.fields['email'] = _email.text.toString();
      request.fields['number'] = _number.text.toString();
      request.fields['address'] = _address.text.toString();
      request.fields['category'] = _selectedItems.toString();
      image != null
          ? request.files.add(http.MultipartFile.fromBytes(
              'business_logo', File(image!.path).readAsBytesSync(),
              filename: image!.path))
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
              '$partnerName Business',
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
              'Manage Your Business',
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
                    label: Text('Business Name'),
                    hintText: 'Enter Business Name'),
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
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    border: InputBorder.none,
                    label: Text('Business Email'),
                    hintText: 'Enter Business Email'),
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
                    label: Text('Business Mobile Number'),
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
                controller: _address,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(Icons.abc_sharp),
                    border: InputBorder.none,
                    label: Text('Business Address'),
                    hintText: 'Enter Business address'),
                style: const TextStyle(fontSize: 14),
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
                hint: const Text('Select Your Category'),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.check_box_outline_blank_sharp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        'Choose Business Logo ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Icon(Icons.image)
                    ],
                  ),
                ),
              ),
            ),
            currentImage != ''
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/default.png',
                          image: currentImage,
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))
                    ],
                  )
                : image != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Image.file(
                            File(image!.path).absolute,
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                          )),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      )
                    : const Text(''),
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
                          updateBusinessDetails();
                        },
                        child: Text(
                          'Update Business Details',
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
