import 'package:get/get.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart'; // 1. Import
import 'package:lost_and_found/app/modules/item_detail/item_detail_controller.dart';

class ItemDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemDetailController>(() => ItemDetailController());
    // 2. Daftarkan ApiProvider
    Get.lazyPut<ApiProvider>(() => ApiProvider());
  }
}
