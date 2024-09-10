import 'dart:io';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  late ListResult result;
  RxBool isLoading = true.obs;
  RxMap progressMap = {}.obs;
  List<File> filesDownload = [];

  @override
  void onInit() {
    super.onInit();
    getUploadedFiles();
  }

  Future<void> recordVideo() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    isLoading.value = true;
    if (video != null) {
      await uploadVideoToDatabase(
        File(
          video.path,
        ),
      );
      getUploadedFiles();
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Video not selected",
          "",
          false,
        ),
      );
      isLoading.value = false;
    }
  }

  Future<void> pickVideo() async {
    final video = await FilePicker.platform.pickFiles();
    isLoading.value = true;
    if (video != null) {
      await uploadVideoToDatabase(File(video.files.first.path!));
      getUploadedFiles();
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Video not selected",
          "",
          false,
        ),
      );
      isLoading.value = false;
    }
  }

  Future<void> downloadVideo(String fileName) async {
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child("Video/$_uid/$fileName");
      String dowmloadUrl = await storageRef.getDownloadURL();
      Dio dio = Dio();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";
      await dio.download(
        dowmloadUrl,
        savePath,
        onReceiveProgress: (count, total) {
          progressMap["$fileName"] = count / total;
        },
      );
      if (dowmloadUrl.contains(".mp4")) {
        await GallerySaver.saveVideo(savePath, toDcim: true);
        progressMap["$fileName"] = 0;
        Get.showSnackbar(
          snackBarWidget(
            "Download Video Success",
            "Video $fileName download success",
            true,
          ),
        );
      } else if (dowmloadUrl.contains(".jpg")) {
        await GallerySaver.saveImage(savePath, toDcim: true);
        Get.showSnackbar(
          snackBarWidget(
            "Download Image Success",
            "Image $fileName download success",
            true,
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
          "Download Video Failed",
          "Video failed : $e",
          false,
        ),
      );
    }
  }

  Future<void> uploadVideoToDatabase(File file) async {
    try {
      String? fileName = await getVideoNameFromUser();
      Reference storageRef =
          FirebaseStorage.instance.ref().child("Video/$_uid/${fileName}.mp4");
      await storageRef.putFile(file);
      Get.showSnackbar(
        snackBarWidget(
          "Upload Success",
          "Video uploaded successfully!",
          true,
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
          "Upload Fail",
          "Failed to upload video : $e!",
          false,
        ),
      );
    }
  }

  Future<void> deleteFileDownload(String fileName) async {
    try {
      isLoading.value = true;
      Directory dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/$fileName";
      File file = File(savePath);
      file.deleteSync();
      await getDownloadFiles();
      isLoading.value = false;
    } catch (e) {}
  }

  Future<void> deleteFile(String fileName) async {
    try {
      isLoading.value = true;
      Reference ref =
          FirebaseStorage.instance.ref().child("Video/$_uid/$fileName");
      await ref.delete();
      Get.showSnackbar(
        snackBarWidget("Delete Success", "Video $fileName deleted", true),
      );
      getUploadedFiles();
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
            "Delete fail", "Failed to delete file $fileName : $e", false),
      );
    }
  }

  Future<void> getUploadedFiles() async {
    isLoading.value = true;
    try {
      progressMap.clear();
      Reference storageRef =
          FirebaseStorage.instance.ref().child("Video/$_uid");
      result = await storageRef.listAll();
      for (Reference ref in result.items) {
        progressMap.addAll({ref.name: 0.0});
      }
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
            "Get Video fail", "Failed to get uploaded video: $e", false),
      );
    }
    isLoading.value = false;
  }

  Future<void> getDownloadFiles() async {
    try {
      isLoading.value = true;
      Directory appDocDir = await getApplicationDocumentsDirectory();

      List<FileSystemEntity> fileList = appDocDir.listSync();

      List<FileSystemEntity> files =
          fileList.where((element) => element.path.contains(".mp4")).toList();
      filesDownload.clear();
      for (var file in files) {
        filesDownload.add(File(file.path));
      }
    } catch (e) {
      Get.showSnackbar(
        snackBarWidget(
          "Open Files Download",
          "Files download open fail : $e",
          false,
        ),
      );
    }
    isLoading.value = false;
  }

  Future<String?> getVideoNameFromUser() async {
    String videoName = "";
    await Get.defaultDialog(
      title: "Enter video name",
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            videoName = value;
          },
          decoration: InputDecoration(hintText: "Enter video name"),
        ),
      ),
      textConfirm: "Confirm",
      textCancel: "Cancel",
      onConfirm: () {
        Get.back();
      },
    );
    return videoName.isNotEmpty ? videoName : null;
  }

  Future<void> openFile(String fileName) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";
      File file = File(savePath);
      if (await file.exists()) {
        await OpenFile.open(savePath);
      } else {
        Get.showSnackbar(
          snackBarWidget(
            "Error",
            "File does not exist: $savePath",
            false,
          ),
        );
      }
    } else {
      Get.showSnackbar(
        snackBarWidget(
          "Error",
          "Permission denied for external storage access",
          false,
        ),
      );
    }
  }
}
