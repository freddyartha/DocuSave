import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewExampleController extends GetxController {
  final webController =
      WebViewController()
        ..setJavaScriptMode(JavaScriptMode.disabled)
        ..loadRequest(Uri.parse("https://flutter.dev/"));
}
