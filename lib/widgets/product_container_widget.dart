import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductContainerWidget extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final IconData icon;
  final String screenPath;

  const ProductContainerWidget(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      required this.icon,
      required this.screenPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(screenPath);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 100,
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Icon(
                icon,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
