import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_todoapp/controllers/home_controller.dart';
import 'package:demo_todoapp/models/item_model.dart';
import 'package:demo_todoapp/widgets/getFileName.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditItemController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  RxBool choosepage = true.obs;
  final db = FirebaseFirestore.instance;
  HomeController homeController = Get.find();
  RxString imageStr = "".obs;
  String? part;

  @override
  void onInit() {
    super.onInit();
    if (homeController.pageAddOrEdit.value == "Edit") {
      name.text = homeController.itemName.value;
      number.text = homeController.itemNumber.value;
      choosepage.value = false;
    }
  }

  Future<String?> pickFile() async {
    final file = await FilePicker.platform.pickFiles(type: FileType.image);
    if (file != null) {
      imageStr.value = file.files.first.path!.split("/").last;
      part = file.files.first.path!;
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Item Not Selected",
          "",
          false,
        ),
      );
    }
    return null;
  }

  Future<void> addItem() async {
    if (part != null) {
      String fileName = await getFileName();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("ItemsImage/${homeController.user.uid}/$fileName.jpg");
      await ref.putFile(File(part!));
      String downloadUrl = await ref.getDownloadURL();
      Item item =
          Item(name: name.text, number: number.text, image: downloadUrl);
      await db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("items")
          .add(item.toJson())
          .then(
        (value) {
          Get.back(result: true);
          Get.showSnackbar(
            snackBarWidget(
              "Add Item",
              "Add item successs.",
              true,
            ),
          );
        },
        onError: (e) => Get.showSnackbar(
          snackBarWidget(
            "Add Item",
            "Add item fail.",
            false,
          ),
        ),
      );
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Add Item",
          "Image item not selected.",
          false,
        ),
      );
    }
  }

  Future<void> editItem() async {
    Map<String, dynamic> data = {"name": name.text, "number": number.text};
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .doc(homeController.editDocumentId.value)
        .update(data)
        .then(
      (value) {
        Get.back(result: true);
        choosepage.value = true;
        Get.showSnackbar(
          snackBarWidget(
            "Edit Item",
            "Edit item successs",
            true,
          ),
        );
      },
      onError: (e) => Get.showSnackbar(
        snackBarWidget(
          "Edit Item",
          "Edit item fail",
          false,
        ),
      ),
    );
  }
}
