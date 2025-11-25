import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';
import 'package:lost_and_found/app/data/api_constants.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';

class LoginController extends GetxController {
  // 1. Siapkan 'kotak' untuk simpan token
  final storage = GetStorage();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    _connect.baseUrl = ApiConstants.baseUrl;
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  void login() async {
    // Validasi sederhana
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);
      final body = {'email': emailC.text, 'password': passwordC.text};
      final response = await _connect.post(
        ApiConstants.login,
        body,
        headers: {'Accept': 'application/json'},
      );

      isLoading(false); // Selesai loading

      // 9. Cek hasil respons
      if (response.isOk && response.body != null) {
        // Sukses
        final loginResponse = LoginResponseModel.fromJson(response.body);
        await storage.write('token', loginResponse.accessToken);
        await storage.write('user', loginResponse.user.toJson());
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'Sukses',
          'Login berhasil!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        if (response.statusCode == 401) {
          Get.snackbar(
            'Error',
            'Kredensial tidak valid (Email/Password salah)',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (response.statusCode == 403) {
          Get.snackbar(
            'Error',
            'Email Belum Terverifikasi. Silakan cek email Anda.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        } else {
          // Error lain
          Get.snackbar(
            'Error',
            'Gagal login: ${response.body?['message'] ?? response.statusText}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      isLoading(false); // Selesai loading
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
