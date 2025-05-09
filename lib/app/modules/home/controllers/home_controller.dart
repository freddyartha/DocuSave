import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:docusave/app/models/article_model.dart';
import 'package:docusave/app/models/warranty_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<ArticleModel> listBanner = <ArticleModel>[].obs;
  final RxList<WarrantyModel> listExpiringWarranties = <WarrantyModel>[].obs;
  var authCon = AuthController.instance;
  void googleLoginOnPress() async {
    await authCon.signInWithGoogle();
  }

  void appleLoginOnPress() async {
    await authCon.signInWithApple();
  }

  List<MenuItemModel> layananList = [];

  RxBool historyLoading = true.obs;
  RxBool articlesLoading = true.obs;

  @override
  void onInit() {
    addLayananList();
    loadArticles();
    loadExpiringWarranties();
    super.onInit();
  }

  @override
  void onReady() async {
    await ReusableStatics.checkingVersion();
    super.onReady();
  }

  void addLayananList() {
    layananList.addAll([
      MenuItemModel(
        title: "receipt",
        image: "assets/images/receipt.png",
        onTab: () => Get.toNamed(Routes.RECEIPT_LIST),
      ),
      MenuItemModel(
        title: "warranty",
        image: "assets/images/warranty.png",
        onTab:
            () => Get.toNamed(Routes.WARRANTY_LIST)?.then((value) {
              loadExpiringWarranties();
            }),
      ),
    ]);
  }

  void loadExpiringWarranties() async {
    historyLoading.value = true;
    if (auth.currentUser != null) {
      var result = await FirebaseRepository.getExpiringWarranties(
        auth.currentUser!.uid,
      );
      if (result != null && result.isNotEmpty) {
        listExpiringWarranties.clear();
        listExpiringWarranties.addAll(result);
      }
    }
    historyLoading.value = false;
  }

  void loadArticles() async {
    articlesLoading.value = true;
    var data = await FirebaseRepository.getArticles();
    if (data != null) {
      listBanner.addAll(data);
    }
    articlesLoading.value = false;
  }

  void goToProfileList() {
    if (auth.currentUser == null) {
      Get.toNamed(Routes.LOGIN);
    } else {
      Get.toNamed(Routes.PROFILE_LIST)?.then((value) => update());
    }
  }

  void goToWarrantySetup(String id) {
    Get.toNamed(Routes.WARRANTY_SETUP, parameters: {"id": id})?.then((value) {
      loadExpiringWarranties();
    });
  }
}
