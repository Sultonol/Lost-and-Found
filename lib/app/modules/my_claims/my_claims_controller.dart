import 'package:get/get.dart';
import 'package:lost_and_found/app/data/models/claim_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';

class MyClaimsController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  var isLoading = true.obs;
  var myClaims = <Claim>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyClaims();
  }

  void fetchMyClaims() async {
    isLoading(true);
    var result = await apiProvider.getMySubmittedClaims();
    myClaims.assignAll(result);
    isLoading(false);
  }
}
