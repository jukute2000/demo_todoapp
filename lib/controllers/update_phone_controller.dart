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
    } on FirebaseException catch (ex) {
      Get.showSnackbar(
        snackBarWidget(
          "Error",
          "$ex",
          false,
        ),
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
      isLoading.value = false;
    }
  }
}
