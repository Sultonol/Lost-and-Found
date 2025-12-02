import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'; // Import Tutorial

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final GetStorage box = GetStorage(); // Storage untuk simpan status tutorial

  // --- 1. SIAPKAN KUNCI (KEYS) UNTUK SOROTAN TUTORIAL ---
  final GlobalKey fabKey = GlobalKey(); // Tombol Tambah (+)
  final GlobalKey notifKey = GlobalKey(); // Tombol Lonceng
  final GlobalKey tabKey = GlobalKey(); // Tab Bar

  var isLoading = true.obs;
  var selectedTabIndex = 0.obs;
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

    fetchReports();
    fetchNotificationCount();
  }

  // Gunakan onReady agar tutorial muncul SETELAH tampilan selesai dirender
  @override
  void onReady() {
    super.onReady();
    // Cek apakah user sudah pernah lihat tutorial?
    if (box.read('hasSeenTutorial') != true) {
      showTutorial();
    }
  }

  @override
  void onClose() {
    _tabController.value?.dispose();
    super.onClose();
  }

  // --- LOGIKA MENAMPILKAN TUTORIAL ---
  void showTutorial() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.context == null) return;

      TutorialCoachMark(
        targets: _createTargets(),
        colorShadow: Colors.black,
        textSkip: "LEWATI",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () {
          box.write('hasSeenTutorial', true);
        },
        onSkip: () {
          box.write('hasSeenTutorial', true);
          return true;
        },
      ).show(context: Get.context!);
    });
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // TARGET 1: TOMBOL TAMBAH (+)
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: fabKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Buat Laporan Baru",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Klik tombol ini jika Anda kehilangan barang atau menemukan barang orang lain.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    // TARGET 2: TAB BAR
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: tabKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Pilih Kategori",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Geser atau klik tab ini untuk melihat daftar 'Barang Hilang' atau 'Barang Ditemukan'.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    // TARGET 3: NOTIFIKASI
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: notifKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Cek Notifikasi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lihat status klaim barang dan pesan masuk dari pengguna lain di sini.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  // --- LOGIKA API (SAMA SEPERTI SEBELUMNYA) ---
  Future<void> fetchReports() async {
    try {
      isLoading(true);
      final responses = await Future.wait([
        apiProvider.getReports(reportType: 'hilang'),
        apiProvider.getReports(reportType: 'ditemukan'),
      ]);
      lostItems.assignAll(responses[0]);
      foundItems.assignAll(responses[1]);
      fetchNotificationCount();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil data: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshAndSetTab(String reportType) async {
    await fetchReports();
    int tabIndex = reportType == 'hilang' ? 0 : 1;
    if (_tabController.value != null) {
      _tabController.value!.animateTo(tabIndex);
    }
  }

  void fetchNotificationCount() async {
    try {
      var claims = await apiProvider.getIncomingClaims();
      notificationCount.value = claims.length;
    } catch (e) {
      print("Gagal mengambil notifikasi: $e");
    }
  }

  Future<void> deleteReport(int id) async {
    try {
      bool success = await apiProvider.deleteReport(id);
      if (success) {
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
