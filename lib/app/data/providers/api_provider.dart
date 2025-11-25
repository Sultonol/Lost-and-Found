import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/api_constants.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/models/category_model.dart';
import 'package:flutter/material.dart';

class ApiProvider extends GetConnect {
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;

    // Menambahkan token otorisasi dan header Accept
    httpClient.addRequestModifier<void>((request) {
      final token = _storage.read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      return request;
    });

    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  // -----------------------------------------------------------------
  // 1. FUNGSI GET REPORTS
  // -----------------------------------------------------------------
  Future<List<Report>> getReports({
    required String reportType,
    String? keyword,
  }) async {
    final query = {
      'report_type': reportType,
      if (keyword != null) 'keyword': keyword,
    };

    try {
      final response = await get(ApiConstants.items, query: query);

      if (response.isOk) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        return Report.fromJsonList(data);
      } else {
        // Error tetap ditampilkan agar tau jika gagal load data
        Get.snackbar(
          "Error API",
          "Gagal mengambil data: ${response.statusText ?? 'Error'}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return [];
      }
    } catch (e) {
      Get.snackbar(
        "Error Koneksi",
        "Tidak dapat terhubung ke server: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }

  // -----------------------------------------------------------------
  // 2. FUNGSI CREATE CLAIM
  // -----------------------------------------------------------------
  Future<bool> createClaim(int itemId) async {
    try {
      final response = await post(ApiConstants.claims, {'item_id': itemId});

      if (response.isOk) {
        // SUKSES: Return true saja, jangan munculkan snackbar (biar controller yang handle)
        return true;
      } else {
        Get.snackbar(
          "Gagal Klaim",
          response.body['message'] ??
              "Gagal membuat klaim: ${response.statusText}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error Koneksi",
        "Tidak dapat terhubung ke server: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // -----------------------------------------------------------------
  // 3. FUNGSI GET CATEGORIES
  // -----------------------------------------------------------------
  Future<List<Category>> getCategories() async {
    try {
      final response = await get(ApiConstants.categories);

      if (response.isOk) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        return Category.fromJsonList(data);
      } else {
        Get.snackbar(
          "Error API",
          "Gagal mengambil daftar kategori: ${response.statusText}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return [];
      }
    } catch (e) {
      Get.snackbar(
        "Error Koneksi",
        "Gagal mengambil kategori: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }

  // -----------------------------------------------------------------
  // 4. FUNGSI CREATE REPORT
  // -----------------------------------------------------------------
  Future<bool> createReport(FormData formData) async {
    try {
      final response = await post(ApiConstants.items, formData);

      if (response.isOk) {
        // SUKSES: Return true saja, jangan munculkan snackbar (biar controller yang handle)
        return true;
      } else {
        // Error handling logic
        String errorMsg = "Gagal membuat laporan: ${response.statusText}";
        if (response.statusCode == 422 &&
            response.body != null &&
            response.body['errors'] != null) {
          errorMsg = "Data tidak valid:\n";
          final errors = response.body['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMsg += "- ${value[0]}\n";
          });
        } else if (response.body != null && response.body['message'] != null) {
          errorMsg = response.body['message'];
        }

        Get.snackbar(
          "Error",
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error Koneksi",
        "Gagal mengirim laporan: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // -----------------------------------------------------------------
  // 5. FUNGSI UPDATE REPORT (DIPERBAIKI UNTUK LARAVEL)
  // -----------------------------------------------------------------
  Future<bool> updateReport(int id, FormData formData) async {
    try {
      // PERBAIKAN PENTING:
      // Tambahkan method spoofing agar Laravel membaca ini sebagai PUT
      // meskipun dikirim lewat POST (karena FormData/Gambar tidak bisa lewat PUT langsung)
      formData.fields.add(const MapEntry('_method', 'PUT'));

      // Gunakan POST, bukan PUT
      final response = await post('${ApiConstants.items}/$id', formData);

      if (response.isOk) {
        // SUKSES: Return true saja, jangan munculkan snackbar (biar controller yang handle)
        return true;
      } else {
        // Error handling logic
        String errorMsg = "Gagal memperbarui laporan: ${response.statusText}";
        if (response.statusCode == 422 &&
            response.body != null &&
            response.body['errors'] != null) {
          errorMsg = "Data tidak valid:\n";
          final errors = response.body['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMsg += "- ${value[0]}\n";
          });
        } else if (response.body != null && response.body['message'] != null) {
          errorMsg = response.body['message'];
        }

        Get.snackbar(
          "Error",
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error Koneksi",
        "Gagal memperbarui laporan: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // -----------------------------------------------------------------
  // 6. FUNGSI DELETE REPORT
  // -----------------------------------------------------------------
  Future<bool> deleteReport(int id) async {
    try {
      final response = await delete('${ApiConstants.items}/$id');

      if (response.isOk) {
        // SUKSES: Return true saja, jangan munculkan snackbar (biar controller yang handle)
        return true;
      } else {
        Get.snackbar(
          "Gagal Hapus",
          response.body['message'] ??
              "Gagal menghapus laporan: ${response.statusText}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error Koneksi",
        "Gagal menghapus laporan: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
