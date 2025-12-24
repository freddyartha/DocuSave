import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/webview_example_controller.dart';

class WebviewExampleView extends GetView<WebviewExampleController> {
  const WebviewExampleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MahasColors.white,
      appBar: ReusableWidgets.generalAppBarWidget(
        title: "Webview Example",
        backgroundColor: MahasColors.white,
      ),
      body: WebViewWidget(controller: controller.webController),
    );
  }
}
