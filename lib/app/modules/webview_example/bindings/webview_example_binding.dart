import 'package:get/get.dart';

import '../controllers/webview_example_controller.dart';

class WebviewExampleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewExampleController>(
      () => WebviewExampleController(),
    );
  }
}
