import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String> getFileName() async {
  String fileName = "";
  await Get.defaultDialog(
    title: "Enter Image Name",
    content: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => fileName = value,
            decoration: InputDecoration(
              labelText: "Enter Image Name",
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Save",
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
  return fileName;
}
