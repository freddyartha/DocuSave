import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
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
                      TextComponent(
                        value: "Welcome Guest!",
                        fontColor: MahasColors.white,
                        fontSize: MahasFontSize.h3,
                        fontWeight: FontWeight.w600,
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

                Padding(
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
                                    (item) => Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: MahasColors.white,
                                        borderRadius: BorderRadius.circular(
                                          MahasRadius.regular,
                                        ),
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
                                ? ReusableWidgets.listLoadingWidget(count: 5)
                                : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 5,
                                  itemBuilder:
                                      (context, index) => Container(
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
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          visualDensity:
                                              VisualDensity.comfortable,
                                          leading: ImageComponent(
                                            localUrl:
                                                "assets/images/receipt.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                          title: TextComponent(
                                            value:
                                                "Judul Kwitansi / Kartu Garansi",
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
                                                      "Akan berakhir pada tanggal",
                                                  fontSize: MahasFontSize.small,
                                                  fontColor: MahasColors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
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
