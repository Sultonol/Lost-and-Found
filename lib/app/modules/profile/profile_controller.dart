import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final GetStorage box = GetStorage();

  // Data user yang sedang login
  var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void loadUserProfile() {
    final userJson = box.read('user');
    if (userJson != null) {
      currentUser.value = User.fromJson(userJson);
    }
  }

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin keluar?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // 1. Hapus data token & user dari penyimpanan
        box.remove('token');
        box.remove('user');

        // 2. Tutup dialog
        Get.back();

        // 3. Lempar ke halaman Login dan hapus semua history page sebelumnya
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}
