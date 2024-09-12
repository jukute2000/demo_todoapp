import 'package:demo_todoapp/views/addedititem.dart';
import 'package:demo_todoapp/views/change_password.dart';
import 'package:demo_todoapp/views/home.dart';
import 'package:demo_todoapp/views/list_videos_download.dart';

import 'package:demo_todoapp/views/signuplogin.dart';
import 'package:demo_todoapp/views/update_infomation_user.dart';
import 'package:demo_todoapp/views/update_otp.dart';
import 'package:demo_todoapp/views/update_phone.dart';
import 'package:demo_todoapp/views/upload_image.dart';
import 'package:demo_todoapp/views/video.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> routePage() => [
      GetPage(
        name: "/loginsignup",
        page: () => const SignupLogin(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/home",
        page: () => const Home(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/add",
        page: () => const AddEditItem(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/changepassword",
        page: () => const ChangePassword(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/updateinfomationuser",
        page: () => const UpdateInfomationUser(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/updateuserphone",
        page: () => const UpdatePhone(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/otp",
        page: () => const OTP(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/video",
        page: () => const Video(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/videosdownload",
        page: () => const VideosDowload(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/image",
        page: () => const UploadImage(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
    ];
