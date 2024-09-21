import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/controllers/locked_content_controller.dart';
import 'package:grofeed_app/models/locked_content_list_model.dart';
import 'package:grofeed_app/screens/locked_content_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditLockedContent extends StatefulWidget {
  final int? content_id;
  const EditLockedContent({super.key, required this.content_id});
  @override
  State<EditLockedContent> createState() => _EditLockedContentState();
}

class _EditLockedContentState extends State<EditLockedContent> {
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
    final id = partner['partner_id'];
    setState(() {
      partnerId = id;
    });
    getLockedContentById();
  }

  bool _isDataLoading = true;
  bool _isLoading = false;
  final lockedContentController = LockedContentController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  List<PlatformFile>? _pickedFiles;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _visibleMessageController =
      TextEditingController();
  final TextEditingController _lockedMessageController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> _categories = [
    'Finance',
    'Education',
    'Food',
    'Job',
    'Entertainment',
    'Travel',
    'Marketing',
    'Fitness',
    'Other',
  ];

  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFiles = result.files;
      });
    }
  }

  void editLockedContent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> formData = {
        'partner_id': partnerId,
        'content_id': widget.content_id.toString(),
        'title': _titleController.text,
        'category': _selectedCategory,
        'visible_message': _visibleMessageController.text,
        'locked_message': _lockedMessageController.text,
        'amount': _amountController.text,
      };
      int result = await lockedContentController.editLockedContent(
          formData, _pickedFiles);
      if (result == 1) {
        Get.offAll(() => const LockedContentScreen());
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Get.snackbar('Ohh!!', 'All Fields are required',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  LockedContentList? lockedContentList;
  List<LockedContent> lockedContent = [];
  void getLockedContentById() async {
    final result = await lockedContentController.getLockedContentById(
        partnerId, widget.content_id.toString());
    if (result != null) {
      lockedContentList = result;
      lockedContentList!.lockedContent?.forEach((element) {
        lockedContent.add(element);
      });
      setState(() {
        _titleController.text = lockedContent[0].title.toString();
        _selectedCategory = lockedContent[0].category.toString();
        _visibleMessageController.text =
            lockedContent[0].visibleMessage.toString();
        _lockedMessageController.text =
            lockedContent[0].lockedMessage.toString();
        _amountController.text = lockedContent[0].amount.toString();
        _isDataLoading = false;
      });
    } else {
      Get.snackbar('Ohh!!', 'No Data found',
          backgroundColor: Colors.red, colorText: Colors.white);
      Get.offAll(() => const LockedContentScreen());
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
                Get.offAll(() => const LockedContentScreen());
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              )),
          title: const Text(
            'Add Locked Content',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 3,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  labelText: 'Title for locked content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: 'Title for locked content',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _visibleMessageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Visible Message',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Visible Message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the visible message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Locked Message field
              TextFormField(
                controller: _lockedMessageController,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  labelText: 'Locked Message',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Locked Message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the locked message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Amount field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // File picker
              ElevatedButton.icon(
                onPressed: _pickFiles,
                icon: const Icon(Icons.attach_file),
                label: const Text('Choose files'),
              ),
              if (_pickedFiles != null && _pickedFiles!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('${_pickedFiles!.length} files selected'),
                ),
              const SizedBox(height: 16.0),

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
                            editLockedContent();
                          },
                          child: Text(
                            'Update Locked Content',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
