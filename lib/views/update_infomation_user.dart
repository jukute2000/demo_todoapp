import 'package:demo_todoapp/controllers/update_information_user_controller.dart';
import 'package:demo_todoapp/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateInfomationUser extends StatelessWidget {
  const UpdateInfomationUser({super.key});

  @override
  Widget build(BuildContext context) {
    UpdateInformationUserController controller =
        Get.put(UpdateInformationUserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("UPDATE INFORMATION USER"),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => Get.back(result: true),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
              right: 12,
              left: 12,
            ),
            width: MediaQuery.of(context).size.width,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: const AssetImage("assets/images/football.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.4), BlendMode.dstATop),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.mail,
                    size: 36,
                  ),
                  title: const Text("Gmail :"),
                  subtitle: Text("${controller.user.email}"),
                ),
                const SizedBox(
                  height: 12,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.phone,
                    size: 36,
                  ),
                  title: const Text("Phone :"),
                  subtitle: Text(controller.user.phoneNumber ?? ""),
                ),
                const SizedBox(
                  height: 12,
                ),
                inputText(
                  keyboardType: TextInputType.name,
                  labelText: "Enter Name",
                  icons: Icons.person,
                  controller: controller.userName,
                  check: false,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: FloatingActionButton(
                        heroTag: "submit_update_username",
                        onPressed: () async {
                          await controller.updateInformationUser();
                        },
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_alt),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Update User Name"),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: FloatingActionButton(
                        heroTag: "move_page_changepassword",
                        backgroundColor: Colors.white.withOpacity(0.8),
                        onPressed: () {
                          controller.movePageChangePassword();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.password),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Change Password")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: FloatingActionButton(
                    heroTag: "move_page_update_userphone",
                    backgroundColor: Colors.white.withOpacity(0.8),
                    onPressed: () {
                      Get.toNamed("/updateuserphone");
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Update User Phone")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
