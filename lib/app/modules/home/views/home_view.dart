import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ReusableWidgets.generalTopHeaderAppBarWidget(children: [
            ]
          ),
          SafeArea(
            child: ListView(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder(
                        builder:
                            (HomeController controller) => Expanded(
                              child: TextComponent(
                                value: "welcome".trParams({
                                  "value":
                                      auth.currentUser != null
                                          ? "${MahasConfig.userProfile?.name}!"
                                          : "Guest!",
                                }),
                                fontColor: MahasColors.white,
                                fontSize: MahasFontSize.h4,
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                                maxLines: 2,
                              ),
                            ),
                      ),
                      GestureDetector(
                        onTap: controller.goToProfileList,
                        child: GetBuilder(
                          builder:
                              (HomeController controller) => Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    MahasRadius.extraLarge,
                                  ),
                                  color: MahasColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: MahasColors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                height: 50,
                                width: 50,
                                clipBehavior: Clip.hardEdge,
                                child:
                                    MahasConfig.userProfile?.profilepic != null
                                        ? ImageComponent(
                                          networkUrl:
                                              MahasConfig
                                                  .userProfile
                                                  ?.profilepic,
                                        )
                                        : ImageComponent(
                                          localUrl: "assets/images/user.png",
                                        ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Obx(
                  () =>
                      controller.articlesLoading.value
                          ? Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: ReusableWidgets.listLoadingWidget(
                              count: 1,
                              height: Get.height * 0.25,
                            ),
                          )
                          : ReusableWidgets.carouselWidget(
                            imageList: controller.listBanner,
                          ),
                ),

                auth.currentUser == null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MahasColors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: MahasColors.black.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: ImageComponent(
                              localUrl: "assets/images/logo.png",
                              height: Get.width * 0.3,
                              width: Get.width,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                          TextComponent(
                            value: "welcome_title".tr,
                            fontWeight: FontWeight.w600,
                            fontSize: MahasFontSize.h5,
                            textAlign: TextAlign.center,
                            margin: EdgeInsets.only(bottom: 5),
                          ),
                          TextComponent(
                            textAlign: TextAlign.center,
                            value: "welcome_subtitle".tr,
                          ),
                          TextComponent(
                            value: "continue_with".tr,
                            fontWeight: FontWeight.w600,
                            fontSize: MahasFontSize.h6,
                            textAlign: TextAlign.center,
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonComponent(
                                  onTap: controller.googleLoginOnPress,
                                  text: "Google",
                                  icon: "assets/images/google.png",
                                  textColor: MahasColors.white,
                                  btnColor: MahasColors.primary,
                                  borderRadius: MahasRadius.large,
                                  fontSize: MahasFontSize.normal,
                                  fontWeight: FontWeight.w600,
                                  isSvg: false,
                                  iconSize: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ButtonComponent(
                                  onTap: controller.appleLoginOnPress,
                                  text: "Apple",
                                  icon: "assets/images/apple.png",
                                  textColor: MahasColors.white,
                                  btnColor: MahasColors.black,
                                  borderRadius: MahasRadius.large,
                                  fontSize: MahasFontSize.normal,
                                  fontWeight: FontWeight.w600,
                                  isSvg: false,
                                  iconSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextComponent(
                            value: "choose_service".tr,
                            fontSize: MahasFontSize.h5,
                            fontWeight: FontWeight.w600,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 20),
                            child: GridView.count(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              physics: NeverScrollableScrollPhysics(),
                              children:
                                  controller.layananList
                                      .map(
                                        (item) => GestureDetector(
                                          onTap: item.onTab,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: MahasColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    MahasRadius.regular,
                                                  ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: MahasColors.black
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 8,
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              spacing: 5,
                                              children: [
                                                ImageComponent(
                                                  localUrl: item.image,
                                                  height: Get.width * 0.25,
                                                  width: Get.width * 0.25,
                                                ),
                                                TextComponent(
                                                  value: item.title!.tr,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          TextComponent(
                            value: "need_your_attention".tr,
                            fontSize: MahasFontSize.h5,
                            fontWeight: FontWeight.w600,
                            margin: EdgeInsets.only(bottom: 5),
                          ),
                          Obx(
                            () =>
                                controller.historyLoading.value
                                    ? ReusableWidgets.listLoadingWidget(
                                      count: 5,
                                    )
                                    : !controller.historyLoading.value &&
                                        controller
                                            .listExpiringWarranties
                                            .isEmpty
                                    ? SizedBox.shrink()
                                    : ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          controller
                                              .listExpiringWarranties
                                              .length,
                                      itemBuilder: (context, index) {
                                        var item =
                                            controller
                                                .listExpiringWarranties[index];
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: MahasColors.white,
                                            borderRadius: BorderRadius.circular(
                                              MahasRadius.regular,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: MahasColors.black
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              if (EasyLoading.isShow) {
                                                EasyLoading.dismiss();
                                              } else {
                                                EasyLoading.show();
                                              }
                                            },
                                            horizontalTitleGap: 10,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3,
                                                ),
                                            visualDensity:
                                                VisualDensity.comfortable,
                                            leading: ImageComponent(
                                              localUrl:
                                                  "assets/images/warranty.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            title: TextComponent(
                                              value: item.itemname,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            subtitle: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      MahasRadius.regular,
                                                    ),
                                                color: MahasColors.yellow,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 3,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.info_outline_rounded,
                                                    color: MahasColors.white,
                                                    size: 15,
                                                  ),
                                                  TextComponent(
                                                    margin: EdgeInsets.only(
                                                      left: 5,
                                                    ),
                                                    value:
                                                        ReusableStatics.getWarrantyRemaining(
                                                          item.warrantyexpirydate
                                                              .toDate(),
                                                        ),
                                                    fontSize:
                                                        MahasFontSize.small,
                                                    fontColor:
                                                        MahasColors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
