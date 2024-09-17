import 'dart:io';

import 'package:demo_todoapp/widgets/getFileName.dart';
import 'package:demo_todoapp/widgets/snackbar_gold.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageController extends GetxController {
  RxBool isChange = true.obs;
  RxBool isLoading = true.obs;
  final ImagePicker picker = ImagePicker();
  final String _userid = FirebaseAuth.instance.currentUser!.uid;
  late ListResult result;
  List<File> imagesDowloaded = [];
  List<String> nameImagesDowloaded = [];
  List<String> listUrlDownload = [];
  late Directory dir;

  @override
  Future<void> onInit() async {
    super.onInit();
    getPhotosUpload();
    dir = await getApplicationDocumentsDirectory();
  }

  void changeView() {
    isChange.value ? isChange.value = false : isChange.value = true;
  }

  Future<void> pickImage() async {
    if (await Permission.photos.request().isGranted) {
      final file = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);
      if (file != null) {
        String fileName = await getFileName();
        isLoading.value = true;
        await uploadFile(File(file.files.single.path!), fileName);
        getPhotosUpload();
      } else {
        Get.showSnackbar(
          snackBarWidget("Image Not Select", "", false),
        );
      }
    }
  }

  Future<void> getPhotoDownloaded() async {
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
      await uploadFile(File(file.path), fileName);
    } else {
      Get.showSnackbar(
        snackBarWidget("File not selected", "", false),
      );
    }
    isLoading.value = false;
  }

  Future<void> uploadFile(File file, String fileName) async {
    Reference ref =
        FirebaseStorage.instance.ref().child("Images/$_userid/$fileName.jpg");
    await ref.putFile(File(file.path)).then(
          (p0) => Get.showSnackbar(
            snackBarWidget("Upload Image", "Image uploaded success", true),
          ),
        );
    await getPhotosUpload();
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

  Future<void> openImage(String fileName) async {
    File file = File("${dir.path}/$fileName");
    if (await Permission.manageExternalStorage.request().isGranted) {
      if (await file.exists()) {
        await OpenFile.open(file.path);
      } else {
        Get.showSnackbar(
          snackBarWidget(
            "Error",
            "File does not exist: ${file.path}",
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
