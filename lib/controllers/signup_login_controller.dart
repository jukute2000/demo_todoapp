import 'package:demo_todoapp/products/auth_provider.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupLoginController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Auth auth = Auth();
  RxBool isLogin = true.obs;

  onChangePage() {
    isLogin.value ? isLogin.value = false : isLogin.value = true;
    nameController.text = "";
    emailController.text = "";
    passwordController.text = "";
  }

  Future<void> OnLogin() async {
    String tmp =
        await auth.loginedAcount(emailController.text, passwordController.text);
    if (tmp == "Login account") {
      Get.showSnackbar(
        snackBarWidget(
          "Login success",
          tmp,
          true,
        ),
      );
      Get.offAndToNamed("/home");
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Login failed",
          tmp,
          false,
        ),
      );
    }
  }

  Future<void> OnSignUp() async {
    String tmp = await auth.createdAccount(
        emailController.text, passwordController.text, nameController.text);
    if (tmp == "Account Created") {
      Get.showSnackbar(
        snackBarWidget(
          "Sign up success",
          tmp,
          true,
        ),
      );
      OnLogin();
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Sign up failed",
          tmp,
          false,
        ),
      );
    }
  }
}
