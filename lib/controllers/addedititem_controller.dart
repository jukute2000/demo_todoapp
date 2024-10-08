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
import 'package:get/get_rx/get_rx.dart';

class AddEditItemController extends GetxController {
  final db = FirebaseFirestore.instance;
  RxBool choosepage = true.obs;
  RxBool isLoading = true.obs;
  HomeController homeController = Get.find();
  TextEditingController name = TextEditingController();
  TextEditingController detail = TextEditingController();
  RxString imageName = "".obs;
  RxString imagePartDownload = "".obs;
  String? partPick;
  String? partPrensent;

  @override
  void onInit() {
    super.onInit();
    if (homeController.pageAddOrEdit == "Edit") {
      name.text = homeController.itemName;
      detail.text = homeController.itemDetail;
      partPrensent = homeController.itemImagePart;
      imageName.value = partPrensent!.split("/").last;
      partPick = "";
      imagePartDownload.value = homeController.itemImagePartDownload;
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
      partPick = result.files.single.path;
      imageName.value = partPick!.split("/").last;
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
    if (partPick != null && partPick!.isNotEmpty) {
      Reference ref = FirebaseStorage.instance.ref().child(
          "ItemsImage/${homeController.auth.currentUser!.uid}/${imageName.value}");
      await ref.putFile(File(partPick!));
      imagePartDownload.value = await ref.getDownloadURL();
      Item item = Item(
        name: name.text,
        detail: detail.text,
        imagePartDowload: imagePartDownload.value,
        imagePart: partPick!,
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
    print(partPick != null && partPick!.isNotEmpty);
    isLoading.value = true;
    if (partPick != null && partPick!.isNotEmpty) {
      String fileName = partPrensent!.split("/").last;
      Reference ref = await FirebaseStorage.instance.ref().child(
          "ItemsImage/${homeController.auth.currentUser!.uid}/$fileName");
      ref.delete();
      fileName = partPick!.split("/").last;
      ref = await FirebaseStorage.instance.ref().child(
          "ItemsImage/${homeController.auth.currentUser!.uid}/$fileName");
      await ref.putFile(File(partPick!));
      imagePartDownload.value = await ref.getDownloadURL();
      partPrensent = partPick;
    }
    Map<String, dynamic> data = {
      "name": name.text,
      "detail": detail.text,
      "imagePart": partPrensent,
      "imagePartDowload": imagePartDownload.value
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
    isLoading.value = false;
  }
}
