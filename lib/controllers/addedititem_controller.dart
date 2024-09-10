import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_todoapp/controllers/home_controller.dart';
import 'package:demo_todoapp/models/item_model.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditItemController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  RxBool choosepage = true.obs;
  final db = FirebaseFirestore.instance;
  HomeController homeController = Get.find();

  @override
  void onInit() {
    super.onInit();
    if (homeController.pageAddOrEdit.value == "Edit") {
      name.text = homeController.itemName.value;
      number.text = homeController.itemNumber.value;
      choosepage.value = false;
    }
  }

  Future<void> addItem() async {
    Item item = Item(name: name.text, number: number.text);
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
            "Add item successs",
            true,
          ),
        );
      },
      onError: (e) => Get.showSnackbar(
        snackBarWidget(
          "Add Item",
          "Add item fail",
          false,
        ),
      ),
    );
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
