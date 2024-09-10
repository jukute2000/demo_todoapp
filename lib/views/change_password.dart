import 'package:demo_todoapp/controllers/changepassword_controller.dart';
import 'package:demo_todoapp/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    ChangePasswordController controller = Get.put(ChangePasswordController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHANGE PASSWORD"),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/images/football.jpg"),
              ),
              const SizedBox(
                height: 12,
              ),
              const Center(
                child: Text(
                  "Change Passwod",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              inputText(
                keyboardType: TextInputType.visiblePassword,
                labelText: "Enter Current Password",
                icons: Icons.password,
                controller: controller.currentPassword,
                check: true,
              ),
              const SizedBox(
                height: 12,
              ),
              inputText(
                keyboardType: TextInputType.visiblePassword,
                labelText: "Enter New Password",
                icons: Icons.password,
                controller: controller.newPassword,
                check: true,
              ),
              const SizedBox(
                height: 12,
              ),
              inputText(
                keyboardType: TextInputType.visiblePassword,
                labelText: "Re-Enter New Password",
                icons: Icons.password,
                controller: controller.reNewPassword,
                check: true,
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 100,
                child: FloatingActionButton(
                  heroTag: "submit_change_password",
                  onPressed: () {
                    controller.onChangePassword();
                  },
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
