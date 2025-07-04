import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/warranty_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class WarrantyListController extends GetxController {
  final searchCon = InputTextController();
  late ListComponentController<WarrantyModel> listCon;
  final defaultQuery = FirebaseRepository.getToWarrantyCollection(
    auth.currentUser!.uid,
  ).orderBy('createdAt', descending: true);

  @override
  void onInit() {
    listCon = ListComponentController(
      query: defaultQuery,
      fromDynamic: WarrantyModel.fromDynamic,
      searchOnType: (value) {
        return listCon.items.where((e) {
          final store = e.storename.toLowerCase();
          final item = e.itemname.toLowerCase();
          final provider = e.warrantyprovider.toLowerCase();
          final serialNumber = e.serialnumber;
          final notes = e.notes.toString().toLowerCase();
          final query = value.toLowerCase();

          return store.contains(query) ||
              item.toString() == query ||
              provider.contains(query) ||
              serialNumber.toString() == query ||
              notes.contains(query);
        }).toList();
      },
    );
    super.onInit();
  }

  void goToWarrantySetup({String? id}) {
    Get.toNamed(
      Routes.WARRANTY_SETUP,
      parameters: id != null ? {"id": id} : null,
    )?.then((value) {
      if (value == true) {
        listCon.refresh();
      }
    });
  }
}
