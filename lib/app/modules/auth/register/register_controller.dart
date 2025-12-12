import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';
import 'package:lost_and_found/app/data/api_constants.dart';

class RegisterController extends GetxController {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  final GetConnect _connect = GetConnect();

  // --- INI PERBAIKANNYA ---
  @override
  void onInit() {
    // Beri tahu GetConnect ini apa baseUrl-nya
    _connect.baseUrl = ApiConstants.baseUrl;
    _connect.timeout = const Duration(seconds: 30);
  }
  // --- AKHIR PERBAIKAN ---

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }

  void register() async {
    // --- Validasi di Sisi Klien (Flutter) ---
    if (nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        passwordC.text.isEmpty ||
        confirmPasswordC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailC.text)) {
      Get.snackbar(
        "Error",
        "Format email tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordC.text.length < 8) {
      Get.snackbar(
        "Error",
        "Password minimal harus 8 karakter",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordC.text != confirmPasswordC.text) {
      Get.snackbar(
        "Error",
        "Password dan Konfirmasi Password tidak cocok",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      final body = {
        'name': nameC.text,
        'email': emailC.text,
        'password': passwordC.text,
        'password_confirmation': confirmPasswordC.text,
        'role': 'mahasiswa', // Selalu 'mahasiswa' saat registrasi
      };

      final response = await _connect.post(
        ApiConstants.register, // Ini sekarang hanya "/register"
        body,
        headers: {'Accept': 'application/json'},
      );

      isLoading(false);

      if (response.isOk) {
        // SUKSES
        Get.snackbar(
          "Registrasi Berhasil",
          "Silakan cek email Anda untuk verifikasi sebelum login.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed(Routes.LOGIN); // Ini sudah benar
      } else {
        // GAGAL (Tangani error dari server)
        if (response.statusCode == 422) {
          if (response.body != null) {
            final errors = response.body as Map<String, dynamic>;
            String errorMessage = "Terjadi error validasi:\n";

            errors.forEach((key, value) {
              errorMessage += "- ${value[0]}\n";
            });

            Get.snackbar(
              'Error Registrasi',
              errorMessage.trim(),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
          } else {
            Get.snackbar(
              'Error',
              'Gagal mendaftar: Data tidak valid (422)',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else if (response.statusCode == 409) {
          Get.snackbar(
            'Error',
            'Gagal: ${response.body?['message'] ?? 'Role admin sudah ada'}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Gagal mendaftar: ${response.statusText ?? 'Error tidak diketahui'}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        'Error',
        'Terjadi kesalahan koneksi: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
