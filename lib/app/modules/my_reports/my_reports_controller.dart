import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';

class MyReportsController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final GetStorage storage = GetStorage();

  var isLoading = true.obs;
  final RxList<Report> myReports = <Report>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyReports();
  }

  // --- Ubah return type ke Future<void> ---
  Future<void> fetchMyReports() async {
    try {
      isLoading(true);

      final userData = storage.read('user');
      if (userData == null) {
        Get.snackbar("Error", "Anda tidak login.");
        isLoading(false);
        return;
      }
      final myUser = User.fromJson(userData as Map<String, dynamic>);
      final int myUserId = myUser.id;

      final responses = await Future.wait([
        apiProvider.getReports(reportType: 'hilang'),
        apiProvider.getReports(reportType: 'ditemukan'),
      ]);

      final allReports = [...responses[0], ...responses[1]];
      final filteredReports = allReports
          .where((report) => report.userId == myUserId)
          .toList();

      myReports.assignAll(filteredReports);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil data laporan saya: ${e.toString()}",
      );
    } finally {
      isLoading(false);
    }
  }

  // --- Tambahkan fungsi refresh untuk pull-to-refresh ---
  Future<void> refreshReports() async {
    await fetchMyReports();
  }
}
