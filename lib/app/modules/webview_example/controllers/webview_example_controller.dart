import 'dart:io';

import 'package:dio/dio.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/mahas/models/web_view_values_model.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewExampleController extends GetxController {
  RxBool downloadWebAssetsLoading = false.obs;

  final webController =
      WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadFile("${MahasConfig.webViewDirectory}/index.html");

  @override
  void onInit() async {
    await remoteConfig.fetchAndActivate();
    String webViewUpdate = remoteConfig.getString("web_view_update");
    if (webViewUpdate.isNotEmpty) {
      MahasConfig.webViewValues = WebViewValuesModel.fromJson(webViewUpdate);
      await checkAndDownloadWebView().then((value) async {
        if (value != null) {
          await ReusableStatics.extractZip(value);
          await ReusableStatics.getLocalWebViewVersion();
          await webController.loadFile(
            "${MahasConfig.webViewDirectory}/index.html",
          );
          downloadWebAssetsLoading(false);
        }
      });
    }

    super.onInit();
  }

  Future<File?> checkAndDownloadWebView() async {
    bool checkUpdate =
        MahasConfig.webViewValues.version != MahasConfig.localWebViewVersion
            ? true
            : false;
    if (auth.currentUser != null && checkUpdate) {
      downloadWebAssetsLoading(true);
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
}
