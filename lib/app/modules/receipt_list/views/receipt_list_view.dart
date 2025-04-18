import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
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
            onTap: controller.goToReceiptSetup,
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
            child: ListComponent(
              controller: controller.listCon,
              itemBuilder:
                  (item, index) => ReusableWidgets.generalShadowedContainer(
                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      horizontalTitleGap: 10,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      title: TextComponent(
                        value: item.storename,
                        fontWeight: FontWeight.w600,
                        fontSize: MahasFontSize.h6,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextComponent(
                            value:
                                "${item.currency} ${InputFormatter.toCurrency(item.totalamount)}",
                          ),
                        ],
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            MahasRadius.regular,
                          ),
                          color: MahasColors.mutedGrey,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 8,
                        ),
                        child: TextComponent(
                          value: item.category,
                          fontSize: MahasFontSize.small,
                          fontColor: MahasColors.white,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
