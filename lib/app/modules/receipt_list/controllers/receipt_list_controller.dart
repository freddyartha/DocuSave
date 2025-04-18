import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/receipt_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ReceiptListController extends GetxController {
  final searchCon = InputTextController();
  final listCon = ListComponentController(
    query: FirebaseFirestore.instance
        .collection(
          "${FirebaseRepository.userCollection}/${auth.currentUser?.uid}/${FirebaseRepository.receiptCollection}",
        )
        .orderBy('createdAt', descending: true),
    fromDynamic: ReceiptModel.fromDynamic,
    searchOnType: (value, item) {
      return [
        item.storename.toLowerCase(),
        item.category.toLowerCase(),
        item.currency.toLowerCase(),
        item.paymentmethod.toLowerCase(),
        item.notes.toString().toLowerCase(),
      ];
    },
  );

  void goToReceiptSetup() {
    Get.toNamed(Routes.RECEIPT_SETUP)?.then((value) {
      if (value == true) {
        listCon.refresh();
      }
    });
  }
}
