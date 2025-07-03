import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class MoneyTrackerHomeController extends GetxController {
  void goToTransactionSetup({String? id}) {
    Get.toNamed(
      Routes.MONEY_TRACKER_SETUP,
      parameters: id != null ? {"id": id} : null,
    )?.then((value) {
      // if (value == true) {
      //   listCon.refresh();
      // }
    });
  }
}
