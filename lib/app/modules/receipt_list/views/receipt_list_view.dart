import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/receipt_list_controller.dart';

class ReceiptListView extends GetView<ReceiptListController> {
  const ReceiptListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ReusableWidgets.generalAppBarWidget(
        title: "receipt".tr,
        backgroundColor: Colors.transparent,
        textColor: MahasColors.white,
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.RECEIPT_SETUP),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ImageComponent(
                localUrl: "assets/images/create.png",
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: MahasColors.white,
      body: Stack(
        children: [
          ReusableWidgets.generalTopHeaderAppBarWidget(children: []),
          SafeArea(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder:
                  (context, index) =>
                      Container(height: 20, color: MahasColors.red),
            ),
          ),
        ],
      ),
    );
  }
}
