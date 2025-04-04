import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:docusave/app/models/article_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<ArticleModel> listBanner = <ArticleModel>[].obs;

  List<MenuItemModel> layananList = [
    MenuItemModel(title: "receipt", image: "assets/images/receipt.png"),
    MenuItemModel(title: "warranty", image: "assets/images/warranty.png"),
  ];

  RxBool historyLoading = true.obs;
  RxBool articlesLoading = true.obs;

  @override
  void onInit() async {
    Future.delayed(Duration(seconds: 3), () => historyLoading.value = false);
    loadArticles();
    super.onInit();
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
}
