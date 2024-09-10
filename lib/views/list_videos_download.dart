import 'dart:io';

import 'package:demo_todoapp/controllers/video_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideosDowload extends StatelessWidget {
  const VideosDowload({super.key});

  @override
  Widget build(BuildContext context) {
    VideoController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text("Videos Download"),
        centerTitle: true,
      ),
      body: Backgroud(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Visibility(
                  visible: controller.isLoading.value,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  replacement: RefreshIndicator(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(8),
                            1: FlexColumnWidth(3),
                          },
                          border: TableBorder.all(color: Colors.white),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.green.shade200,
                              ),
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("File Name"),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Button"),
                                  ),
                                ),
                              ],
                            ),
                            ...List.generate(
                              controller.filesDownload.length,
                              (index) {
                                File file = controller.filesDownload[index];
                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                  ),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(file.path.split("/").last),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Column(
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              await controller.openFile(
                                                  file.path.split("/").last);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Play",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await controller
                                                  .deleteFileDownload(file.path
                                                      .split("/")
                                                      .last);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () => controller.getDownloadFiles(),
                  ),
                ),
        ),
      ),
    );
  }
}
