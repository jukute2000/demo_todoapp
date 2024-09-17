import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_todoapp/controllers/home_controller.dart';
import 'package:demo_todoapp/models/item_model.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddEditItemController extends GetxController {
  final db = FirebaseFirestore.instance;
  RxBool choosepage = true.obs;
  RxBool isLoading = true.obs;
  HomeController homeController = Get.find();
  TextEditingController name = TextEditingController();
  TextEditingController detail = TextEditingController();
  RxString imageName = "".obs;
  String imagePartDownload = "";
  String? part;
  String? editPart;

  @override
  void onInit() {
    super.onInit();
    if (homeController.pageAddOrEdit == "Edit") {
      name.text = homeController.itemName;
      detail.text = homeController.itemDetail;
      imageName.value = homeController.itemImagePart.split("/").last;
      part = "";
      editPart = homeController.itemImagePart;
      imagePartDownload = homeController.itemImagePartDownload;
      choosepage.value = false;
    }
    isLoading.value = false;
  }

  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      part = result.files.single.path;
      imageName.value = part!.split("/").last;
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
    isLoading.value = true;
    if (part != null && part!.isNotEmpty) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("ItemsImage/${homeController.user.uid}/${imageName.value}");
      await ref.putFile(File(part!));
      imagePartDownload = await ref.getDownloadURL();
      Item item = Item(
        name: name.text,
        detail: detail.text,
        imagePartDowload: imagePartDownload,
        imagePart: part!,
      );
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
    isLoading.value = false;
  }

  Future<void> editItem() async {
    if (part != null) {
      String fileName = editPart!.split("/").last;
      Reference ref = await FirebaseStorage.instance
          .ref()
          .child("ItemsImage/${homeController.user.uid}/$fileName.jpg");
      ref.delete();
      fileName = part!.split("/").last;
      ref = await FirebaseStorage.instance
          .ref()
          .child("ItemsImage/${homeController.user.uid}/$fileName.jpg");
      ref.putFile(File(part!));
      imagePartDownload = await ref.getDownloadURL();
    } else {
      part = editPart;
    }

    Map<String, dynamic> data = {
      "name": name.text,
      "detail": detail.text,
      "imagePart": part,
      "imagePartDowload": imagePartDownload
    };
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
