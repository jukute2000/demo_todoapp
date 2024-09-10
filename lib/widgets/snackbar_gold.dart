import 'package:flutter/material.dart';
import 'package:get/get.dart';

snackBarWidget(String title, String content, bool isSuccess) {
  return GetSnackBar(
    padding: const EdgeInsets.all(20),
    backgroundColor: Colors.white.withOpacity(0.8),
    titleText: Text(
      title,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    messageText: Text(
      content,
      style: TextStyle(color: Colors.grey),
    ),
    duration: Duration(seconds: 3),
    icon: isSuccess
        ? Icon(
            Icons.done,
            color: Colors.green,
          )
        : Icon(
            Icons.delete,
            color: Colors.red,
          ),
  );
}
