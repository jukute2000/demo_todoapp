import 'package:demo_todoapp/controllers/update_phone_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
import 'package:demo_todoapp/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePhone extends StatelessWidget {
  const UpdatePhone({super.key});

  @override
  Widget build(BuildContext context) {
    UpdatePhoneController controller = Get.put(UpdatePhoneController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("UPDATE PHONE"),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Get.back(result: true),
          ),
        ),
        body: Backgroud(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inputText(
                    keyboardType: TextInputType.phone,
                    labelText: "Enter Phone",
                    icons: Icons.phone,
                    controller: controller.userPhone,
                    check: false,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 130,
                    child: FloatingActionButton(
                      heroTag: "Receive_OTP",
                      backgroundColor: Colors.white.withOpacity(0.6),
                      onPressed: () async {
                        await controller.verifyPhoneNumber();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call_received),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Receive OTP"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
