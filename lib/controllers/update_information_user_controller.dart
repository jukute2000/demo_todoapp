import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateInformationUserController extends GetxController {
  User user = FirebaseAuth.instance.currentUser!;
  TextEditingController userName = TextEditingController();
  RxBool isLoading = true.obs;

  Future<void> updateInformationUser() async {
    try {
      await user.updateProfile(displayName: userName.text).then(
        (value) {
          Get.showSnackbar(
            snackBarWidget(
              "Update User Name",
              "Update user name success",
              true,
            ),
          );
        },
      );
    } on FirebaseException catch (e) {
      Get.showSnackbar(
        snackBarWidget(
          "Update User Name",
          e.code,
          false,
        ),
      );
    } catch (ex) {
      Get.showSnackbar(
        snackBarWidget(
          "Update User Name",
          "$ex",
          false,
        ),
      );
    }
  }

  void movePageChangePassword() {
    Get.toNamed("/changepassword");
  }

  @override
  void onInit() {
    super.onInit();
    userName.text = user.displayName ?? "";
  }
}
