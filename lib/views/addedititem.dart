import 'package:demo_todoapp/controllers/addedititem_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
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
        body: Backgroud(
          child: controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                          height: 12,
                        ),
                        inputText(
                          keyboardType: TextInputType.text,
                          labelText: "Enter Detail",
                          icons: Icons.note,
                          controller: controller.detail,
                          check: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                padding: EdgeInsets.all(12),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.grey.shade200,
                                ),
                                child: Obx(
                                  () => Text(
                                    controller.imageName == ""
                                        ? "Choose Image"
                                        : "${controller.imageName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: FloatingActionButton(
                                heroTag: "Put Item Image",
                                backgroundColor: Colors.white.withOpacity(0.8),
                                onPressed: () async {
                                  await controller.pickFile();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.file_upload),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text("Choose File")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: FloatingActionButton(
                            heroTag: "submit_add_or_edit",
                            backgroundColor: Colors.white.withOpacity(0.6),
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
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
