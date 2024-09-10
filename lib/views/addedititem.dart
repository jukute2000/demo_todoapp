import 'package:demo_todoapp/controllers/addedititem_controller.dart';
import 'package:demo_todoapp/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditItem extends StatelessWidget {
  const AddEditItem({super.key});

  @override
  Widget build(BuildContext context) {
    AddEditItemController controller = Get.put(AddEditItemController());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back(result: true);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(controller.choosepage.value ? "ADD ITEM" : "EDIT ITEM"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: const AssetImage("assets/images/football.jpg"),
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inputText(
                    keyboardType: TextInputType.name,
                    labelText: "Enter Name",
                    icons: Icons.person,
                    controller: controller.name,
                    check: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputText(
                    keyboardType: TextInputType.phone,
                    labelText: "Enter Number",
                    icons: Icons.numbers,
                    controller: controller.number,
                    check: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: FloatingActionButton(
                      heroTag: "submit_add_or_edit",
                      backgroundColor: Colors.white,
                      onPressed: () {
                        controller.choosepage.value
                            ? controller.addItem()
                            : controller.editItem();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_alt),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
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
