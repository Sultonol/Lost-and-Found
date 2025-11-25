import 'package:get/get.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart'; // IMPORT
import 'package:lost_and_found/app/modules/add_report/add_report_controller.dart';

class AddReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddReportController>(() => AddReportController());
    // Daftarkan ApiProvider agar bisa dipakai controller
    Get.lazyPut<ApiProvider>(() => ApiProvider());
  }
}
