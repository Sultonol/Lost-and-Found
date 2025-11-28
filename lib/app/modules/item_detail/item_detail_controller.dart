import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';
import 'package:lost_and_found/app/modules/home/home_controller.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';
import 'package:lost_and_found/app/theme/app_theme.dart';

class ItemDetailController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final GetStorage storage = GetStorage();

  late final Rx<Report> report;
  final RxInt myUserId = 0.obs;

  var isClaiming = false.obs;
  var isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Report) {
      report = (Get.arguments as Report).obs;
    } else {
      Get.back();
      Get.snackbar("Error", "Data laporan invalid");
    }
    loadMyUserId();
  }

  void loadMyUserId() {
    final userData = storage.read('user');
    if (userData != null) {
      final myUser = User.fromJson(userData as Map<String, dynamic>);
      myUserId.value = myUser.id;
    }
  }

  // --- WIDGET TOMBOL AKSI ---
  Widget buildActionButton() {
    if (myUserId.value == 0) return const SizedBox.shrink();

    // 1. JIKA PEMILIK: Tampilkan Edit & Hapus
    if (report.value.userId == myUserId.value) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onEditPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Edit"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: isDeleting.value ? null : onDeletePressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: isDeleting.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Hapus"),
            ),
          ),
        ],
      );
    }

    // 2. JIKA ORANG LAIN:
    if (report.value.status == 'claimed') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "BARANG SEDANG DALAM PROSES KLAIM",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    if (report.value.status == 'closed') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "BARANG SUDAH DIKEMBALIKAN (SELESAI)",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
      );
    }

    if (report.value.reportType == 'ditemukan' &&
        report.value.status == 'open') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isClaiming.value ? null : createClaim,
          child: isClaiming.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text("KLAIM BARANG INI"),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void onEditPressed() {
    Get.toNamed(Routes.ADD_REPORT, arguments: report.value);
  }

  void onDeletePressed() {
    Get.defaultDialog(
      title: "Hapus Laporan",
      middleText: "Yakin hapus?",
      textConfirm: "Ya",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        isDeleting(true);
        bool success = await apiProvider.deleteReport(report.value.id);
        isDeleting(false);
        if (success) {
          _refreshDataInBackground();
          Get.back(); // Tutup detail view
        }
      },
    );
  }

  // =========================================================================
  // LOGIKA KLAIM BARU (MIRIP SUBMIT REPORT)
  // =========================================================================
  void createClaim() {
    Get.defaultDialog(
      title: "Konfirmasi Klaim",
      middleText: "Yakin ingin mengklaim barang ini? Penemu akan diberitahu.",
      textConfirm: "Ya, Klaim",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primaryColor,
      onConfirm: () async {
        // 1. TUTUP DIALOG KONFIRMASI TERLEBIH DAHULU
        Get.back();

        // 2. MULAI LOADING
        isClaiming(true);

        try {
          // 3. PANGGIL API
          bool success = await apiProvider.createClaim(report.value.id);

          // 4. MATIKAN LOADING
          isClaiming(false);

          // 5. CEK HASIL
          if (success) {
            // Tampilkan Pesan Sukses
            Get.snackbar(
              "Berhasil",
              "Permintaan klaim dikirim. Tunggu persetujuan penemu.",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );

            // 6. REDIRECT DAN REFRESH (LOGIKA PENTING)
            if (Get.isRegistered<HomeController>()) {
              final homeC = Get.find<HomeController>();

              // a. Refresh data di Home agar status terupdate
              await homeC.fetchReports();

              // b. Pindah ke tab 'Barang Ditemukan' (index 1) karena klaim biasanya di situ
              if (homeC.tabController != null) {
                homeC.tabController!.animateTo(1);
              }

              // c. PAKSA PINDAH KE HOME (Menutup halaman detail)
              // Menggunakan Get.offNamed memastikan kita tidak 'stuck' di halaman detail
              Get.offNamed(Routes.HOME);
            } else {
              // Fallback jika masuk dari deeplink atau tidak ada Home
              Get.back();
            }
          }
        } catch (e) {
          // Tangani Error dengan baik
          isClaiming(false);
          Get.snackbar(
            "Error",
            "Terjadi kesalahan saat klaim: ${e.toString()}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  void _refreshDataInBackground() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchReports();
    }
  }
}
