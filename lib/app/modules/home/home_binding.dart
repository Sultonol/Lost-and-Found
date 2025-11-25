import 'package:get/get.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart'; // 1. Import provider
import 'package:lost_and_found/app/modules/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    // 2. Daftarkan ApiProvider di sini
    //    agar bisa "ditemukan" oleh HomeController
    Get.lazyPut<ApiProvider>(() => ApiProvider());
  }
}
