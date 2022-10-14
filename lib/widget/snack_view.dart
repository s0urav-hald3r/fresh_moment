import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static showSnack(String title, String msg) {
    Get.snackbar(title, msg,
        titleText: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        messageText: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        barBlur: 0,
        backgroundColor: Colors.purple,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 2000));
  }
}
