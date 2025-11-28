import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  var isLoading = true.obs;
  var selectedTabIndex = 0.obs;

  // --- 1. VARIABEL UNTUK MENYIMPAN JUMLAH NOTIFIKASI ---
  // Ini yang menyebabkan error "notificationCount isn't defined" sebelumnya.
  var notificationCount = 0.obs;

  final RxList<Report> lostItems = <Report>[].obs;
  final RxList<Report> foundItems = <Report>[].obs;

  final Rxn<TabController> _tabController = Rxn<TabController>();
  TabController? get tabController => _tabController.value;

  @override
  void onInit() {
    super.onInit();
    _tabController.value = TabController(length: 2, vsync: this);
    _tabController.value!.addListener(() {
      selectedTabIndex.value = _tabController.value!.index;
    });

    // Ambil data laporan
    fetchReports();

    // --- 2. AMBIL JUMLAH NOTIFIKASI SAAT APLIKASI DIBUKA ---
    fetchNotificationCount();
  }

  @override
  void onClose() {
    _tabController.value?.dispose();
    super.onClose();
  }

  Future<void> fetchReports() async {
    try {
      isLoading(true);

      final responses = await Future.wait([
        apiProvider.getReports(reportType: 'hilang'),
        apiProvider.getReports(reportType: 'ditemukan'),
      ]);

      lostItems.assignAll(responses[0]);
      foundItems.assignAll(responses[1]);

      // --- 3. REFRESH JUGA NOTIFIKASI SETIAP KALI DATA DI-REFRESH ---
      // Agar badge merah selalu update jika ada klaim baru
      fetchNotificationCount();
    } catch (e) {
      print("[v0] Error fetching reports: ${e.toString()}");
      Get.snackbar(
        "Error",
        "Gagal mengambil data dari server: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshAndSetTab(String reportType) async {
    await fetchReports();
    // Set tab berdasarkan reportType (hilang = 0, ditemukan = 1)
    int tabIndex = reportType == 'hilang' ? 0 : 1;
    if (_tabController.value != null) {
      _tabController.value!.animateTo(tabIndex);
    }
  }

  // --- 4. FUNGSI UNTUK MENGAMBIL DATA KLAIM MASUK ---
  void fetchNotificationCount() async {
    try {
      // Mengambil data klaim yang masuk (pending) dari API Provider
      var claims = await apiProvider.getIncomingClaims();

      // Update jumlah notifikasi sesuai panjang list data yang diterima
      notificationCount.value = claims.length;
    } catch (e) {
      print("Gagal mengambil notifikasi: $e");
    }
  }

  // --- 5. FUNGSI DELETE (Agar bisa dipanggil dari mana saja di Home) ---
  Future<void> deleteReport(int id) async {
    try {
      bool success = await apiProvider.deleteReport(id);
      if (success) {
        // Refresh data setelah menghapus agar item hilang dari list
        await fetchReports();
        Get.snackbar(
          "Sukses",
          "Laporan berhasil dihapus",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus: $e");
    }
  }
}
