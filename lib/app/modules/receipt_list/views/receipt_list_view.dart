import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
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
                  (item, index) => Container(
                    margin: EdgeInsets.all(10),
                    color: MahasColors.white,
                    child: ListTile(
                      title: Text(item.storename),
                      subtitle: Text(item.totalamount.toString()),
                    ),
                  ),
            ),

            // Obx(
            //   () => Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(
            //           left: 20,
            //           right: 20,
            //           bottom: 10,
            //         ),
            //         child: Row(
            //           children: [
            //             Expanded(
            //               child: InputTextComponent(
            //                 controller: controller.searchCon,
            //                 placeHolder: "Cari",
            //                 prefixIcon: Icon(Icons.search_outlined),
            //                 marginBottom: 0,
            //               ),
            //             ),
            //             Container(
            //               margin: EdgeInsets.only(left: 10),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(
            //                   MahasRadius.regular,
            //                 ),
            //                 color: MahasColors.lightgray,
            //               ),
            //               padding: EdgeInsets.all(10),
            //               child: Icon(Icons.filter_alt_outlined),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         child: RefreshIndicator(
            //           onRefresh: () async {
            //             controller.lastDoc = null;
            //             controller.fetchReceipts();
            //           },
            //           child: ListView.builder(
            //             controller: controller.scrollController,
            //             itemCount:
            //                 controller.receipts.length +
            //                 (controller.isLoading.value ? 1 : 0),
            //             itemBuilder: (context, index) {
            //               if (index < controller.receipts.length) {
            //                 final item = controller.receipts[index];
            //                 return ListTile(
            //                   title: Text(item.storename),
            //                   subtitle: Text(item.totalamount.toString()),
            //                 );
            //               } else {
            //                 return Align(
            //                   alignment: Alignment.bottomCenter,
            //                   child: TextComponent(
            //                     value: "loading".tr,
            //                     fontColor: MahasColors.primary,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 );
            //               }
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
