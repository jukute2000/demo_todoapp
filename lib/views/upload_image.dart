import 'package:demo_todoapp/controllers/image_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadImage extends StatelessWidget {
  const UploadImage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ImageController controller = Get.put(ImageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("UPLOAD IMAGE"),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                controller.changeView();
              },
              icon: Icon(
                controller.isChange.value ? Icons.menu : Icons.window_outlined,
              ),
            ),
          )
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Backgroud(
                child: Visibility(
                  visible: controller.isLoading.value,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  replacement: RefreshIndicator(
                    onRefresh: () => controller.getPhotosUpload(),
                    child: SafeArea(
                      child: GridView.builder(
                        itemCount: controller.result.items.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              controller.isChange.value ? 500 : 250,
                        ),
                        itemBuilder: (context, index) {
                          Reference ref = controller.result.items[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  if (controller.isChange.value)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: size.height / 4.5,
                                        child: Image(
                                          image: NetworkImage(
                                            controller.listUrlDownload[index],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Text(
                                        "File name:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        ref.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 16,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      controller.nameImagesDowloaded
                                              .contains(ref.name)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () async {},
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.done,
                                                        size: 24,
                                                        color: Colors.green,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "Have",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    await controller
                                                        .downloadImageUpload(
                                                            controller
                                                                    .listUrlDownload[
                                                                index],
                                                            ref.name);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.download,
                                                        size: 24,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "Download",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              await controller
                                                  .deleteImageUpload(controller
                                                      .result
                                                      .items[index]
                                                      .name);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  size: 24,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: PopupMenuButton(
        onSelected: (value) async {
          if (value == "take") {
            await controller.takePhotoUpload();
          } else if (value == "pick") {}
        },
        color: Colors.white.withOpacity(0.8),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: "take",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Take a photo"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "pick",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Pick a photo"),
                ],
              ),
            )
          ];
        },
        icon: Icon(
          Icons.add_circle,
          size: 56,
          color: Colors.grey.withOpacity(0.8),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: Container(
          color: Colors.white60,
        ),
      ),
    );
  }
}
