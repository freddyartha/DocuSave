import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/money_tracker_model.dart';
import 'package:docusave/app/modules/money_tracker_chart/controllers/money_tracker_chart_controller.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class MoneyTrackerListController extends GetxController {
  late ListComponentController<MoneyTrackerModel> listCon;
  final defaultQuery = FirebaseRepository.getToMoneyTrackerCollection(
    auth.currentUser!.uid,
  ).orderBy('createdAt', descending: true);

  final MoneyTrackerChartController chartController =
      Get.isRegistered<MoneyTrackerChartController>()
          ? Get.find<MoneyTrackerChartController>()
          : Get.put(MoneyTrackerChartController());

  @override
  void onInit() {
    listCon = ListComponentController(
      query: defaultQuery,
      fromDynamic: MoneyTrackerModel.fromDynamic,
      searchOnType: (value) {
        return [];
      },
    );

    super.onInit();
  }

  void goToTransactionSetup({String? id}) {
    Get.toNamed(
      Routes.MONEY_TRACKER_SETUP,
      parameters: id != null ? {"id": id} : null,
    )?.then((value) async {
      if (value == true) {
        listCon.refresh();
        chartController.getThisMonthChart();
      }
    });
  }
}
