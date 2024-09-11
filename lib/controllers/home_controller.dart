import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/item_model.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Item> items = <Item>[].obs;
  RxList<String> itemsId = <String>[].obs;
  final db = FirebaseFirestore.instance;
  //thuoc tinh qua page edit
  RxString pageAddOrEdit = "Add".obs;
  RxString itemName = "".obs;
  RxString itemNumber = "".obs;
  RxString editDocumentId = "".obs;
  //thuoc tinh user
  User user = FirebaseAuth.instance.currentUser!;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxString userN = "".obs;
  TextEditingController userName = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getItems();
    getDataUser();
  }

  movePageUpdateInfomationUser() {
    Get.toNamed("/updateinfomationuser")?.then(
      (value) {
        if (value) {
          getDataUser();
        }
      },
    );
  }

  Future<void> logout() async {
    Get.deleteAll();
    await auth.signOut().then(
          (value) => Get.showSnackbar(
            snackBarWidget(
              "Logout",
              "Logout success",
              true,
            ),
          ),
        );
    Get.offAllNamed("/loginsignup");
  }

  Future<void> getDataUser() async {
    user = FirebaseAuth.instance.currentUser!;
    userName.text = user.displayName ?? "";
    userN.value = user.displayName ?? "";
  }

  void movePage(String name, String number, String id) {
    pageAddOrEdit.value = "Edit";
    itemName.value = name;
    itemNumber.value = number;
    editDocumentId.value = id;
    Get.toNamed("/add")?.then(
      (value) {
        if (value) {
          getItems();
        }
      },
    );
  }

  Future<void> deleteItem(String itemId) async {
    await db
        .collection("users")
        .doc(user.uid)
        .collection("items")
        .doc(itemId)
        .delete()
        .then(
      (value) {
        getItems();
        Get.showSnackbar(
          snackBarWidget(
            "Document deleted",
            "Document deleted success",
            true,
          ),
        );
      },
      onError: (e) => Get.showSnackbar(
        snackBarWidget(
          "Document deleted",
          "Document deleted fail : $e",
          false,
        ),
      ),
    );
  }

  Future<void> getItems() async {
    itemName.value = "";
    itemNumber.value = "";
    editDocumentId.value = "";
    pageAddOrEdit.value = "Add";
    isLoading.value = true;
    items.clear();
    itemsId.clear();
    var result =
        await db.collection("users").doc(user.uid).collection("items").get();
    for (var item in result.docs) {
      itemsId.add(item.id);
      items.add(
        Item.fromToJson(
          item.data(),
        ),
      );
    }
    isLoading.value = false;
  }
}
