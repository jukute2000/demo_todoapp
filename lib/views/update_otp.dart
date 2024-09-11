import 'package:demo_todoapp/controllers/update_phone_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
import 'package:demo_todoapp/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTP extends StatelessWidget {
  const OTP({super.key});

  @override
  Widget build(BuildContext context) {
    UpdatePhoneController controller = Get.find();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          ),
          title: Text("SEND OTP"),
          centerTitle: true,
        ),
        body: controller.isLoading.value
            ? Center(child: const CircularProgressIndicator())
            : Backgroud(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputText(
                          keyboardType: TextInputType.number,
                          labelText: "Enter OTP",
                          icons: Icons.article,
                          controller: controller.phoneOTP,
                          check: false,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: FloatingActionButton(
                            heroTag: "Send_OTP",
                            onPressed: () async {
                              await controller.UpdateSmsCode();
                              Get.offAndToNamed("/home");
                            },
                            backgroundColor: Colors.white.withOpacity(0.6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Send"),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
