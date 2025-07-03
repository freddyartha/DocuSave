import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/money_tracker_home_controller.dart';

class MoneyTrackerHomeView extends GetView<MoneyTrackerHomeController> {
  const MoneyTrackerHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: ReusableWidgets.generalAppBarWidget(
        title: "money_tracker".tr,
        backgroundColor: Colors.transparent,
        textColor: MahasColors.white,
        actions: [
          GestureDetector(
            onTap: controller.goToTransactionSetup,
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

          // SafeArea(
          //   child: ListComponent(
          //     controller: controller.listCon,
          //     itemBuilder:
          //         (item, index) => ReusableWidgets.generalShadowedContainer(
          //           margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          //           child: ListTile(
          //             onTap:
          //                 () =>
          //                     controller.goToServiceSetup(id: item.documentid),
          //             titleAlignment: ListTileTitleAlignment.top,
          //             horizontalTitleGap: 10,
          //             visualDensity: VisualDensity.compact,
          //             contentPadding: EdgeInsets.symmetric(
          //               vertical: 5,
          //               horizontal: 10,
          //             ),
          //             title: TextComponent(
          //               value: item.storename,
          //               fontWeight: FontWeight.w600,
          //               fontSize: MahasFontSize.h6,
          //             ),
          //             subtitle: TextComponent(
          //               value:
          //                   "${item.currency} ${InputFormatter.toCurrency(item.price)}",
          //             ),
          //             trailing: Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(
          //                   MahasRadius.regular,
          //                 ),
          //                 color: MahasColors.mutedGrey,
          //               ),
          //               padding: EdgeInsets.symmetric(
          //                 vertical: 3,
          //                 horizontal: 8,
          //               ),
          //               child: TextComponent(
          //                 value: InputFormatter.displayDate(
          //                   item.createdat.toDate(),
          //                 ),
          //                 fontSize: MahasFontSize.small,
          //                 fontColor: MahasColors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
