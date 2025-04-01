import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            MahasRadius.extraLarge,
                          ),
                          color: MahasColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: MahasColors.black.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        height: 60,
                        width: 60,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ReusableWidgets.carouselWidget(
                  imageList: controller.listBanner,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
