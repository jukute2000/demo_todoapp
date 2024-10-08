import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../models/item_model.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isView = true.obs;
  RxList<Item> items = <Item>[].obs;
  RxList<String> itemsId = <String>[].obs;
  final db = FirebaseFirestore.instance;
  //thuoc tinh qua page edit
  String pageAddOrEdit = "Add";
  String itemName = "";
  String itemDetail = "";
  String itemImagePart = "";
  String itemImagePartDownload = "";
  RxString editDocumentId = "".obs;
  //thuoc tinh user
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    getItems();
    getDataUser();
  }

  void changeView() {
    isView.value ? isView.value = false : isView.value = true;
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
    try {
      await auth.signOut();
      Get.showSnackbar(
        snackBarWidget(
          "Logout",
          "Logout success",
          true,
        ),
      );

      if (auth.currentUser == null) {
        Get.delete<HomeController>();
        Get.offAllNamed("/loginsignup");
      } else {
        print("User is still signed in: ${auth.currentUser?.uid}");
      }
    } catch (error) {
      Get.showSnackbar(
        snackBarWidget(
          "Logout Failed",
          "Error: $error",
          false,
        ),
      );
    }
  }

  Future<void> getDataUser() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.reload();
    } else {
      Get.offAllNamed("/loginsignup");
    }
  }

  void movePage(String name, String detail, String id, String filePart,
      String imagePartDownload) {
    pageAddOrEdit = "Edit";
    itemName = name;
    itemDetail = detail;
    itemImagePart = filePart;
    itemImagePartDownload = imagePartDownload;
    editDocumentId.value = id;
    Get.toNamed("/add")?.then(
      (value) {
        if (value) {
          getItems();
        }
      },
    );
  }

  Future<void> deleteItem(String itemId, String fileName) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("ItemsImage/${auth.currentUser!.uid}/$fileName");
    ref.delete();
    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
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
    if (auth.currentUser != null) {
      itemName = "";
      itemDetail = "";
      itemImagePart = "";
      itemImagePartDownload = "";
      editDocumentId.value = "";
      pageAddOrEdit = "Add";
      isLoading.value = true;
      items.clear();
      itemsId.clear();
      var result = await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("items")
          .get();
      for (var item in result.docs) {
        itemsId.add(item.id);
        items.add(
          Item.fromToJson(
            item.data(),
          ),
        );
      }
      isLoading.value = false;
    } else {
      Get.offAllNamed("/loginsignup");
    }
  }
}
