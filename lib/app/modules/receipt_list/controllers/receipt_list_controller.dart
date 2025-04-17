import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/receipt_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
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
    searchCon: InputTextController(),
  );

  RxList<ReceiptModel> receipts = <ReceiptModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  DocumentSnapshot? lastDoc;

  final ScrollController scrollController = ScrollController();
  final int perPage = 10;

  @override
  void onInit() {
    fetchReceipts();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        fetchReceipts(clearAllData: false);
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchReceipts({bool clearAllData = true}) async {
    if (clearAllData) {
      receipts.clear();
      lastDoc = null;
    }
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    Query query = FirebaseFirestore.instance
        .collection(
          "${FirebaseRepository.userCollection}/${auth.currentUser?.uid}/${FirebaseRepository.receiptCollection}",
        )
        .orderBy('createdAt', descending: true)
        .limit(perPage);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDoc = snapshot.docs.last;
      for (var result in snapshot.docs) {
        receipts.add(ReceiptModel.fromDynamic(result.data()));
      }
    } else {
      hasMore.value = false;
    }

    isLoading.value = false;
  }

  void goToReceiptSetup() {
    Get.toNamed(Routes.RECEIPT_SETUP)?.then((value) {
      print(value);
      if (value == true) {
        listCon.refresh();
      }
    });
  }
}
