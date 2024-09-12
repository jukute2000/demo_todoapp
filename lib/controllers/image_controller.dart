import 'dart:io';

import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageController extends GetxController {
  RxBool isChange = true.obs;
  RxBool isLoading = true.obs;
  final ImagePicker picker = ImagePicker();
  final String _userid = FirebaseAuth.instance.currentUser!.uid;
  late ListResult result;
  List<File> imagesDowloaded = [];
  List<String> nameImagesDowloaded = [];
  List<String> listUrlDownload = [];

  @override
  void onInit() {
    super.onInit();
    getPhotosUpload();
  }

  void changeView() {
    isChange.value ? isChange.value = false : isChange.value = true;
  }

  Future<void> getPhotoDownloaded() async {
    Directory dir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = dir.listSync();
    List<FileSystemEntity> files = fileList
        .where(
          (element) => element.path.contains(".jpg"),
        )
        .toList();
    if (files.isNotEmpty) {
      imagesDowloaded.clear();
      nameImagesDowloaded.clear();
      files.forEach(
        (element) {
          imagesDowloaded.add(File(element.path));
          nameImagesDowloaded.add(element.path.split('/').last);
        },
      );
    }
  }

  Future<void> getPhotosUpload() async {
    isLoading.value = true;
    listUrlDownload.clear();
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child("Images/$_userid");
      result = await storageRef.listAll();
      await getPhotoDownloaded();
      for (Reference ref in result.items) {
        listUrlDownload.add(await ref.getDownloadURL());
      }
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget("Get Image", "Get image failed", false),
      );
    }
    isLoading.value = false;
  }

  Future<void> takePhotoUpload() async {
    isLoading.value = true;
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    String fileName = await getFileName();
    if (file != null && fileName != "") {
      Reference ref =
          FirebaseStorage.instance.ref().child("Images/$_userid/$fileName.jpg");
      await ref.putFile(File(file.path));
      await getPhotosUpload();
      Get.showSnackbar(
        snackBarWidget("Upload Image", "Image uploaded success", true),
      );
    } else {
      Get.showSnackbar(
        snackBarWidget("Upload Image", "Image uploaded fail", false),
      );
    }
    isLoading.value = false;
  }

  Future<void> deleteImageUpload(String fileName) async {
    Reference ref =
        FirebaseStorage.instance.ref().child("Images/$_userid/$fileName");
    try {
      isLoading.value = true;
      await ref.delete();
      Get.showSnackbar(
        snackBarWidget("Image Delete", "Image deleted success", true),
      );
      getPhotosUpload();
    } on Exception catch (e) {
      Get.showSnackbar(
        snackBarWidget("Image Delete", "Image deleted fail : $e", false),
      );
      isLoading.value = false;
    }
  }

  Future<void> downloadImageUpload(String urlDownload, String fileName) async {
    try {
      Dio dio = Dio();
      Directory dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/$fileName";
      await dio.download(
        urlDownload,
        savePath,
      );
      await GallerySaver.saveImage(savePath, toDcim: true);
      Get.showSnackbar(
        snackBarWidget(
          "Download Image Success",
          "Image $fileName download success",
          true,
        ),
      );
      getPhotosUpload();
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
          "Download Image Failed",
          "Image failed : $e",
          false,
        ),
      );
    }
  }

  Future<String> getFileName() async {
    String fileName = "";
    await Get.defaultDialog(
      title: "Enter Image Name",
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => fileName = value,
              decoration: InputDecoration(
                labelText: "Enter Image Name",
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Save",
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    return fileName;
  }
}
