import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';
import 'package:lost_and_found/app/modules/home/home_controller.dart';
import 'package:lost_and_found/app/modules/my_reports/my_reports_controller.dart';
import 'package:lost_and_found/app/theme/app_theme.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';

class ItemDetailController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final GetStorage storage = GetStorage();

  final Rx<Report> report = (Get.arguments as Report).obs;
  final RxInt myUserId = 0.obs;

  var isClaiming = false.obs;
  var isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyUserId();
  }

  void loadMyUserId() {
    final userData = storage.read('user');
    if (userData != null) {
      final myUser = User.fromJson(userData as Map<String, dynamic>);
      myUserId.value = myUser.id;
    }
  }

  Widget buildActionButton() {
    if (myUserId.value == 0) return const SizedBox.shrink();

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
      title: "Konfirmasi Hapus",
      middleText: "Anda yakin ingin menghapus laporan ini?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        // 1. TUTUP DIALOG KONFIRMASI DULUAN
        Get.back();

        // 2. Mulai Loading di tombol
        isDeleting(false);

        // 3. Panggil API
        bool success = await apiProvider.deleteReport(report.value.id);

        // 4. Matikan Loading
        isDeleting(false);

        if (success) {
          // 5. JIKA SUKSES -> Langsung Tutup Halaman Detail
          // Kita gunakan Navigator.pop untuk lebih aman menutup halaman
          // daripada Get.back() yang kadang menutup snackbar
          Get.back();

          // 6. Refresh data di background
          _refreshDataInBackground();
        }
      },
    );
  }

  void createClaim() {
    Get.defaultDialog(
      title: "Konfirmasi Klaim",
      middleText: "Yakin ingin mengklaim barang ini?",
      textConfirm: "Ya, Klaim",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        isClaiming(true);
        bool success = await apiProvider.createClaim(report.value.id);
        isClaiming(false);

        if (success) {
          Get.offNamed(Routes.MY_CLAIMS);
          _refreshDataInBackground();
        }
      },
    );
  }

  void _refreshDataInBackground() {
    try {
      if (Get.isRegistered<HomeController>())
        Get.find<HomeController>().fetchReports();
      if (Get.isRegistered<MyReportsController>())
        Get.find<MyReportsController>().fetchMyReports();
    } catch (_) {}
  }
}
