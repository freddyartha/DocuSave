import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewExampleController extends GetxController {
  final webController =
      WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadFile("${MahasConfig.webViewDirectory}/index.html");
}
