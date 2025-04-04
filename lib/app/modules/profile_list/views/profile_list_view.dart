import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_list_controller.dart';

class ProfileListView extends GetView<ProfileListController> {
  const ProfileListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ReusableWidgets.generalAppBarWidget(
        title: "profile".tr,
        backgroundColor: Colors.transparent,
        textColor: MahasColors.white,
      ),
      backgroundColor: MahasColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ReusableWidgets.generalTopHeaderAppBarWidget(children: []),
              SafeArea(
                child: Align(
                  child: GetBuilder(
                    builder:
                        (ProfileListController controller) => Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  MahasRadius.extraLarge * 2,
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
                              height: 100,
                              width: 100,
                              clipBehavior: Clip.hardEdge,
                              child:
                                  MahasConfig.userProfile?.profilepic != null
                                      ? ImageComponent(
                                        networkUrl:
                                            MahasConfig.userProfile?.profilepic,
                                      )
                                      : ImageComponent(
                                        localUrl: "assets/images/user.png",
                                      ),
                            ),
                            TextComponent(
                              value: MahasConfig.userProfile?.name,
                              fontWeight: FontWeight.w600,
                              fontSize: MahasFontSize.h5,
                              fontColor: MahasColors.white,
                            ),
                            TextComponent(
                              value: MahasConfig.userProfile?.email,
                              fontColor: MahasColors.white,
                            ),
                          ],
                        ),
                  ),
                ),
              ),
              Positioned(
                right: Get.width * 0.2,
                top: 50,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: controller.goToProfileSetup,
                    child: Icon(
                      Icons.edit_rounded,
                      color: MahasColors.white,
                      size: 30,
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          offset: Offset(0, 6),
                          color: MahasColors.black.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.listProfiles.length,
              itemBuilder: (context, index) {
                var item = controller.listProfiles[index];
                return ListTile(
                  onTap: item.onTab,
                  horizontalTitleGap: 10,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(item.icon, color: MahasColors.darkgray),
                  title: TextComponent(
                    value: item.title!.tr,
                    fontWeight: FontWeight.w600,
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: MahasColors.darkgray,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
