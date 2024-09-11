import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  User user = FirebaseAuth.instance.currentUser!;
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController reNewPassword = TextEditingController();
  RxBool isChangePassword = false.obs;

  onChangePassword() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email.toString(), password: currentPassword.text)
          .then(
        (value) async {
          if (newPassword.text == reNewPassword.text) {
            await user.updatePassword(newPassword.text);
            isChangePassword.value = true;
          } else {
            Get.showSnackbar(
              snackBarWidget(
                "Change password fail",
                "New password and re-new password not like",
                false,
              ),
            );
          }
        },
      );
      if (isChangePassword.value) {
        Get.showSnackbar(
          snackBarWidget(
            "Change password",
            "Change password successs",
            true,
          ),
        );
        Get.deleteAll();
        Get.offAndToNamed("/home");
      }
    } on FirebaseException catch (e) {
      if (e.code == "weak-password") {
        Get.showSnackbar(
          snackBarWidget(
            "Change password fail",
            "the password is not strong enough.",
            false,
          ),
        );
      }
      Get.showSnackbar(
        snackBarWidget(
          "Change password fail",
          e.code,
          false,
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
          "Change password fail",
          "$e",
          false,
        ),
      );
    }
  }
}
