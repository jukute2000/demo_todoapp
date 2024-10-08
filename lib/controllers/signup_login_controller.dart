import 'package:demo_todoapp/products/auth_provider.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupLoginController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Auth auth = Auth();
  RxBool isLogin = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Đặt các giá trị controller về null khi khởi tạo
    clearControllers();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void onChangePage() {
    isLogin.value = !isLogin.value;
    clearControllers(); // Xóa giá trị trong các controller
  }

  Future<void> OnLoginFacebook() async {
    String tmp = await auth.loginedFacebook();
    handleLoginResponse(tmp);
  }

  Future<void> OnLoginGoogle() async {
    String tmp = await auth.loginedGoogle();
    handleLoginResponse(tmp);
  }

  Future<void> OnLogin() async {
    String tmp =
        await auth.loginedAcount(emailController.text, passwordController.text);
    handleLoginResponse(tmp);
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
      await OnLogin(); // Gọi đăng nhập ngay sau khi tạo tài khoản
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

  void handleLoginResponse(String response) {
    if (response == "Login account") {
      Get.showSnackbar(
        snackBarWidget(
          "Login success",
          response,
          true,
        ),
      );
      Get.offAndToNamed("/home");
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Login failed",
          response,
          false,
        ),
      );
    }
  }
}
