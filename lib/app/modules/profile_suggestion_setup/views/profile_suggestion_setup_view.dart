import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import 'package:get/get.dart';

import '../controllers/profile_suggestion_setup_controller.dart';

class ProfileSuggestionSetupView
    extends GetView<ProfileSuggestionSetupController> {
  const ProfileSuggestionSetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return ReusableWidgets.generalPopScopeWidget(
      showConfirmationCondition: controller.showConfirmationCondition,
      child: Scaffold(
        backgroundColor: MahasColors.white,
        extendBodyBehindAppBar: true,
        appBar: ReusableWidgets.generalAppBarWidget(
          title: "suggestion_tittle".tr,
          backgroundColor: MahasColors.white,
        ),
        body: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            physics: ClampingScrollPhysics(),
            children: [
              TextComponent(
                value: "give_rating".tr,
                fontWeight: FontWeight.w600,
                fontSize: MahasFontSize.h6,
              ),
              Obx(
                () => Center(
                  child: RatingStars(
                    value: controller.rating.value,
                    onValueChanged: (v) {
                      controller.rating.value = v;
                    },
                    starBuilder:
                        (index, color) => Icon(
                          Icons.star_rounded,
                          size: Get.width / 5.5,
                          color: color ?? MahasColors.primary,
                        ),
                    starCount: 5,
                    starSize: Get.width / 5.5,
                    valueLabelColor: MahasColors.mediumgray,
                    valueLabelRadius: 10,
                    maxValue: 5,
                    starSpacing: 0.0,
                    maxValueVisibility: false,
                    valueLabelVisibility: false,
                    animationDuration: Duration(milliseconds: 1000),
                    valueLabelPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    valueLabelMargin: const EdgeInsets.only(right: 10),
                    starOffColor: MahasColors.mutedGrey,
                    starColor: MahasColors.yellow,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InputTextComponent(
                controller: controller.feedbackCon,
                label: "feedback".tr,
                placeHolder: "feedback_hint".tr,
                required: true,
                marginBottom: 15,
                editable: true,
              ),
              InputTextComponent(
                controller: controller.suggestionCon,
                label: "suggestion".tr,
                placeHolder: "suggestion_hint".tr,
                required: true,
                marginBottom: 15,
                editable: true,
              ),
              Obx(
                () => ButtonComponent(
                  onTap: controller.saveOnTap,
                  text: "save".tr,
                  btnColor:
                      controller.buttonActive.value
                          ? MahasColors.primary
                          : MahasColors.mediumgray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
