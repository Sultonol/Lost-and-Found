import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/api_constants.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/models/category_model.dart';
import 'package:lost_and_found/app/data/models/claim_model.dart';
import 'package:lost_and_found/app/data/models/message_model.dart';
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
  // 2. FUNGSI CREATE CLAIM (Mengajukan Klaim)
  // -----------------------------------------------------------------
  Future<bool> createClaim(int itemId) async {
    try {
      final response = await post(ApiConstants.claims, {'item_id': itemId});

      if (response.isOk) {
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
        return true;
      } else {
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
  // 5. FUNGSI UPDATE REPORT
  // -----------------------------------------------------------------
  Future<bool> updateReport(int id, FormData formData) async {
    try {
      formData.fields.add(const MapEntry('_method', 'PUT'));

      final response = await post('${ApiConstants.items}/$id', formData);

      if (response.isOk) {
        return true;
      } else {
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

  // =================================================================
  // METHOD BARU UNTUK NOTIFIKASI & APPROVAL
  // =================================================================

  // -----------------------------------------------------------------
  // 7. AMBIL LIST NOTIFIKASI KLAIM MASUK
  // -----------------------------------------------------------------
  Future<List<Claim>> getIncomingClaims() async {
    try {
      final response = await get('${ApiConstants.claims}/incoming');

      // Debugging Log
      print("=== CEK JSON DARI LARAVEL ===");
      print("URL: ${ApiConstants.claims}/incoming");
      print("Status Code: ${response.statusCode}");
      print("Raw Body: ${response.bodyString}");
      print("=============================");

      if (response.isOk) {
        final List<dynamic> data = response.body['data'];
        return Claim.fromJsonList(data);
      }
      return [];
    } catch (e) {
      print("Error getIncomingClaims: $e");
      return [];
    }
  }

  // -----------------------------------------------------------------
  // 8. RESPON KLAIM (APPROVE / REJECT) - [INI YANG DITAMBAHKAN]
  // -----------------------------------------------------------------
  Future<bool> respondToClaim(int claimId, String status) async {
    // status: 'approved' atau 'rejected'
    try {
      // Gunakan PUT untuk update status di endpoint /claims/{id}
      final response = await put('${ApiConstants.claims}/$claimId', {
        'status': status,
      });

      if (response.isOk) {
        return true;
      } else {
        Get.snackbar(
          "Gagal",
          response.body['message'] ?? "Gagal memproses klaim",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Kesalahan koneksi: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // -----------------------------------------------------------------
  // 9. AMBIL CHAT (GET MESSAGES) - BARU
  // -----------------------------------------------------------------
  Future<List<Message>> getMessages(int claimId) async {
    try {
      final response = await get('${ApiConstants.claims}/$claimId/messages');
      print("=== DEBUG CHAT ===");
      print("URL: ${ApiConstants.claims}/$claimId/messages");
      print("STATUS: ${response.statusCode}");
      print("==================");

      if (response.isOk) {
        List<dynamic> listData = [];

        if (response.body is Map && response.body['data'] != null) {
          listData = response.body['data'];
        } else if (response.body is List) {
          listData = response.body;
        }

        return Message.fromJsonList(listData);
      } else {
        print("Gagal ambil chat: ${response.statusText}");
        return [];
      }
    } catch (e) {
      print("Error getMessages (Exception): $e");
      return [];
    }
  }

  // -----------------------------------------------------------------
  // 10. KIRIM PESAN (SEND MESSAGE) - BARU
  // -----------------------------------------------------------------
  Future<bool> sendMessage(int claimId, String messageContent) async {
    try {
      final response = await post('${ApiConstants.claims}/$claimId/messages', {
        'message': messageContent, // Key 'message' sesuai validasi Laravel kamu
      });
      return response.isOk;
    } catch (e) {
      print("Error sendMessage: $e");
      return false;
    }
  }

  Future<List<Claim>> getMySubmittedClaims() async {
    try {
      final response = await get('${ApiConstants.claims}/my-submitted');
      if (response.isOk) {
        final List<dynamic> data = response.body['data'];
        return Claim.fromJsonList(data);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
