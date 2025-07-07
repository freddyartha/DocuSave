import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/money_tracker_home_controller.dart';

class MoneyTrackerHomeView extends GetView<MoneyTrackerHomeController> {
  const MoneyTrackerHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: ReusableWidgets.generalAppBarWidget(
        title: "money_tracker".tr,
        backgroundColor: MahasColors.white,
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
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MahasColors.primary),
                    borderRadius: BorderRadius.circular(MahasRadius.regular),
                  ),
                  child: Row(
                    spacing: 5,
                    children: List.generate(controller.headerMenus.length, (
                      index,
                    ) {
                      var item = controller.headerMenus[index];
                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selectedIndex.value = index;
                            item.onTab != null ? item.onTab!() : null;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  index == controller.selectedIndex.value
                                      ? MahasColors.primary
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(
                                MahasRadius.regular - 1,
                              ),
                            ),
                            child: Center(
                              child: TextComponent(
                                value: item.title,
                                fontColor:
                                    index == controller.selectedIndex.value
                                        ? Colors.white
                                        : MahasColors.primary,
                                fontSize: MahasFontSize.h6,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: controller.pages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
