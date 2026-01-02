import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:docusave/app/models/article_model.dart';
import 'package:docusave/app/models/warranty_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class HomeController extends GetxController {
  final RxList<ArticleModel> listBanner = <ArticleModel>[].obs;
  final RxList<WarrantyModel> listExpiringWarranties = <WarrantyModel>[].obs;
  var authCon = AuthController.instance;
  RxBool demo = false.obs;
  final updater = ShorebirdUpdater();

  void googleLoginOnPress() async {
    await authCon.signInWithGoogle();
  }

  void appleLoginOnPress() async {
    await authCon.signInWithApple();
  }

  void demoOnPress() async {
    await authCon.singInWithPassword('demo@demo.com', '123456');
  }

  List<MenuItemModel> layananList = [];

  RxBool historyLoading = true.obs;
  RxBool articlesLoading = true.obs;

  @override
  void onInit() {
    demo.value = MahasConfig.demo;
    addLayananList();
    loadArticles();
    loadExpiringWarranties();
    super.onInit();
  }

  @override
  void onReady() async {
    await ReusableStatics.checkingVersion();
    await _checkShoreBirdUpdate();
    await checkAndDownloadWebView().then((value) async {
      if (value != null) {
        await extractZip(value);
      }
    });
    super.onReady();
  }

  Future<File?> checkAndDownloadWebView() async {
    bool checkUpdate =
        MahasConfig.webViewValues.prevVersion <
                MahasConfig.webViewValues.version
            ? true
            : false;
    if (checkUpdate) {
      // Ambil download URL
      final ref = FirebaseRepository.getWebDataFirebaseStorage(
        MahasConfig.webViewValues.fileName,
      );
      final url = await ref.getDownloadURL();

      // Ambil directory lokal
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${ref.name}';

      final dio = Dio();

      await dio.download(url, filePath);

      return File(filePath);
    } else {
      return null;
    }
  }

  Future<void> extractZip(File zipFile) async {
    final dir = await getApplicationSupportDirectory();
    final webDir = Directory('${dir.path}/web_view');

    if (await webDir.exists()) {
      await webDir.delete(recursive: true);
    }

    await webDir.create();

    final bytes = zipFile.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = '${webDir.path}/${file.name}';

      if (file.isFile) {
        final outFile = File(filename);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      } else {
        await Directory(filename).create(recursive: true);
      }
    }

    MahasConfig.webViewDirectory = webDir.path;
  }

  Future<void> _checkShoreBirdUpdate() async {
    final status = await updater.checkForUpdate();

    if (status == UpdateStatus.outdated) {
      try {
        // Perform the update
        await updater.update();
      } on UpdateException catch (error) {
        ReusableWidgets.notifBottomSheet(
          title: "failed_install_update".tr,
          subtitle: error.toString(),
        );
      }
    }
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
      MenuItemModel(
        title: "service",
        image: "assets/images/service.png",
        onTab: () => Get.toNamed(Routes.SERVICE_LIST),
      ),
      MenuItemModel(
        title: "money_tracker",
        image: "assets/images/money_tracker.png",
        onTab: () => Get.toNamed(Routes.MONEY_TRACKER_HOME),
      ),
    ]);
  }

  void loadExpiringWarranties() async {
    historyLoading(true);
    if (auth.currentUser != null) {
      var result = await FirebaseRepository.getExpiringWarranties(
        auth.currentUser!.uid,
      );
      if (result != null && result.isNotEmpty) {
        listExpiringWarranties.clear();
        listExpiringWarranties.addAll(result);
      }
    }
    historyLoading(false);
  }

  void loadArticles() async {
    articlesLoading(true);
    var data = await FirebaseRepository.getArticles();
    if (data != null) {
      listBanner.addAll(data);
    }
    articlesLoading(false);
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

  void showWebView() {
    if (MahasConfig.webViewDirectory.isNotEmpty) {
      Get.toNamed(Routes.WEBVIEW_EXAMPLE);
    } else {
      ReusableWidgets.notifBottomSheet(
        title: "WebView Belum Terunduh",
        subtitle: "Konten Web View belum terunduh di perangkat Anda",
      );
    }
  }
}
