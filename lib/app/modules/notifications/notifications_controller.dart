import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/data/models/claim_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';
import 'package:lost_and_found/app/modules/home/home_controller.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';

class NotificationsController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  var isLoading = true.obs;
  var incomingClaims = <Claim>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchIncomingClaims();
  }

  void fetchIncomingClaims() async {
    isLoading(true);
    var result = await apiProvider.getIncomingClaims();
    incomingClaims.assignAll(result);
    isLoading(false);
  }

  void processClaim(int claimId, bool isApproved) {
    String status = isApproved ? 'approved' : 'rejected';
    String actionText = isApproved ? "menerima" : "menolak";
    Color confirmColor = isApproved ? Colors.green : Colors.red;

    Get.defaultDialog(
      title: "Konfirmasi",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText:
          "Anda yakin ingin $actionText permintaan klaim ini?\n\n"
          "${isApproved ? 'Barang akan ditandai sebagai SELESAI.' : 'Permintaan akan dihapus dari daftar.'}",
      textConfirm: "Ya, $actionText",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: confirmColor,
      onConfirm: () async {
        Get.back(); // Tutup dialog konfirmasi
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        bool success = await apiProvider.respondToClaim(claimId, status);

        Get.back(); // Tutup loading dialog

        if (success) {
          Get.snackbar(
            "Sukses",
            "Berhasil $actionText klaim.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          fetchIncomingClaims();
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().fetchReports();
          }
        }
      },
    );
  }

  void viewItemDetail(Claim claim) {
    if (claim.item != null) {
      Get.toNamed(Routes.ITEM_DETAIL, arguments: claim.item);
    }
  }
}
