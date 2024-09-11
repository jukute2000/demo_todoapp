import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UpdatePhoneController extends GetxController {
  TextEditingController userPhone = TextEditingController();
  TextEditingController phoneOTP = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  String verifiId = '';
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    userPhone.text = user.phoneNumber ?? "";
  }

  Future<void> verifyPhoneNumber() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+84${userPhone.text}",
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (error) {
          Get.showSnackbar(
            snackBarWidget(
              "Failed To Verify Phone Number",
              "${error.message}",
              false,
            ),
          );
        },
        codeSent: (verificationId, forceResendingToken) {
          verifiId = verificationId;
          Get.toNamed("/otp");
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verifiId = verificationId;
        },
      );
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
          "Error",
          "$e",
          false,
        ),
      );
    }
  }

  Future<void> UpdateSmsCode() async {
    if (phoneOTP.text.isEmpty) {
      Get.showSnackbar(
        snackBarWidget(
          "Error",
          "OTP not null",
          false,
        ),
      );
    } else {
      isLoading.value = true;
      try {
        String smsCode = phoneOTP.text.trim();
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verifiId, smsCode: smsCode);
        await FirebaseAuth.instance.currentUser!
            .updatePhoneNumber(credential)
            .then(
              (value) => Get.showSnackbar(
                snackBarWidget(
                  "Update User Phone",
                  "Update user phone success",
                  true,
                ),
              ),
            );
      } on FirebaseException catch (e) {
        if (e.code == "invalid-verification-code") {
          Get.showSnackbar(
            snackBarWidget(
              "Update User Phone",
              "The verification code of the credential is not valid.",
              false,
            ),
          );
        }
      }
      isLoading.value = false;
    }
  }
}
