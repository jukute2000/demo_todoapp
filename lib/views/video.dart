import 'package:demo_todoapp/controllers/video_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Video extends StatelessWidget {
  const Video({super.key});

  @override
  Widget build(BuildContext context) {
    VideoController controller = Get.put(VideoController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("UPLOAD VIDEO"),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white.withOpacity(0.9),
            onSelected: (value) async {
              if (value == "Record") {
                await controller.recordVideo();
              } else if (value == "Pick") {
                await controller.pickVideo();
              } else if (value == "Open Videos") {
                await controller.getDownloadFiles();
                Get.toNamed("/videosdownload");
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "Record",
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Recording Video And Upload"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Pick",
                  child: Row(
                    children: [
                      Icon(Icons.folder_open),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Pick Video And Upload"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Open Videos",
                  child: Row(
                    children: [
                      Icon(Icons.folder),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Open Videos Download"),
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Backgroud(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Visibility(
                    visible: controller.isLoading.value,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    replacement: RefreshIndicator(
                      onRefresh: () => controller.getUploadedFiles(),
                      child: SafeArea(
                        child: GridView.builder(
                          itemCount: controller.result.items.length,
                          padding: EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250),
                          itemBuilder: (context, index) {
                            var ref = controller.result.items[index];
                            return Card(
                              color: Colors.white.withOpacity(0.9),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "File Name : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      ref.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Obx(
                                      () {
                                        return controller
                                                    .progressMap[ref.name] !=
                                                0.0
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: LinearProgressIndicator(
                                                  value: controller
                                                      .progressMap[ref.name],
                                                  backgroundColor: Colors.grey,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            : TextButton(
                                                onPressed: () async {
                                                  await controller
                                                      .downloadVideo(
                                                    ref.name,
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.download,
                                                      size: 24,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "Download",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            await controller
                                                .deleteFile(ref.name);
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
      ),
    );
  }
}
