import 'package:get/get.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart'; // 1. Import
import 'package:lost_and_found/app/modules/my_reports/my_reports_controller.dart';

class MyReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyReportsController>(() => MyReportsController());

    // 2. Tambahkan ini agar controller bisa Get.find<ApiProvider>()
    Get.lazyPut<ApiProvider>(() => ApiProvider());
  }
}
