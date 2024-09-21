import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grofeed_app/controllers/locked_content_controller.dart';
import 'package:grofeed_app/models/locked_content_list_model.dart';
import 'package:grofeed_app/screens/addLockedContent.dart';
import 'package:grofeed_app/screens/editLockedContent.dart';
import 'package:grofeed_app/screens/index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LockedContentScreen extends StatefulWidget {
  const LockedContentScreen({super.key});

  @override
  State<LockedContentScreen> createState() => _LockedContentScreenState();
}

class _LockedContentScreenState extends State<LockedContentScreen> {
  bool _isDataLoading = true;
  String partnerId = '';
  final lockedContentController = LockedContentController();
  LockedContentList? lockedContentList;
  List<LockedContent> lockedContent = [];
  List<bool> activeStat = [];
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
    getLockedContentList();
  }

  void getLockedContentList() async {
    final result =
        await lockedContentController.getLockedContentList(partnerId);
    if (result != null) {
      lockedContentList = result;
      lockedContentList!.lockedContent?.forEach((element) {
        lockedContent.add(element);
        activeStat.add(false);
      });
      setState(() {
        _isDataLoading = false;
      });
    } else {
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String content_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text(
              'Are you sure you want to delete this locked content?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await deleteLockedContent(content_id); // Call delete function
              },
            ),
          ],
        );
      },
    );
  }

  deleteLockedContent(String contentId) async {
    int response =
        await lockedContentController.deleteLockedContent(partnerId, contentId);
    print(response);
    if (response == 1) {
      setState(() {
        lockedContent.clear();
        _isDataLoading = true;
      });
      getLockedContentList();
    }
  }

  void _showShareDialog(BuildContext context, String title, String url) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Share URL or Copy'),
            actions: [
              TextButton(
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child:
                    const Text('Done', style: TextStyle(color: Colors.green)),
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    shareOnWhatsApp(title, url);
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(
                      'assets/images/whatsapp.png',
                      width: 25,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    copyDataToClipBoard(title, url);
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(
                      'assets/images/copy.png',
                      width: 25,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void copyDataToClipBoard(String title, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar('Hurry', 'URL copied',
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void shareOnWhatsApp(String title, String url) async {
    final whatsAppShareUrl = 'https://api.whatsapp.com/send?text=$title\n$url';
    if (await canLaunchUrl(Uri.parse(whatsAppShareUrl))) {
      await launchUrl(Uri.parse(whatsAppShareUrl));
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
                      initialIndex: 2,
                    ));
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              )),
          title: const Text(
            'Locked Contents',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 3,
        ),
      ),
      body: _isDataLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 8,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: lockedContent.length,
                  itemBuilder: (context, index) {
                    int myIndex = index + 1;
                    return Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white54)),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                activeStat[index] = !activeStat[index];
                              });
                            },
                            horizontalTitleGap: 0,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$myIndex.'),
                              ],
                            ),
                            title: Text(lockedContent[index].title.toString()),
                            subtitle: Text(
                                'Visible Message : ${lockedContent[index].visibleMessage}'),
                            trailing:
                                Text(lockedContent[index].amount.toString()),
                          ),
                          activeStat[index]
                              ? Column(
                                  children: [
                                    const Divider(
                                      color: Colors.white60,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => EditLockedContent(
                                                content_id: int.parse(
                                                    lockedContent[index]
                                                        .lockedContentId
                                                        .toString())));
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _showDeleteConfirmationDialog(
                                                context,
                                                lockedContent[index]
                                                    .lockedContentId
                                                    .toString());
                                          },
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _showShareDialog(
                                                context,
                                                lockedContent[index]
                                                    .title
                                                    .toString(),
                                                lockedContent[index]
                                                    .shareUrl
                                                    .toString());
                                          },
                                          child: const Icon(
                                            Icons.share,
                                            color: Colors.blue,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddLockedContent());
        },
        tooltip: 'Add',
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 40,
        ),
      ),
    );
  }
}
