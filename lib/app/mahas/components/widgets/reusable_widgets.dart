import 'package:carousel_slider/carousel_slider.dart';
import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:docusave/app/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

enum NotifType { success, warning }

class ReusableWidgets {
  static Widget generalTopHeaderAppBarWidget({
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      height: Get.height * 0.35,
      decoration: BoxDecoration(
        color: MahasColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(MahasRadius.extraLarge),
          bottomRight: Radius.circular(MahasRadius.extraLarge),
        ),
      ),
      width: Get.width,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [...children],
      ),
    );
  }

  static PreferredSizeWidget generalAppBarWidget({
    required String title,
    Widget? leading,
    List<Widget>? actions,
    Color backgroundColor = MahasColors.primary,
    Color textColor = MahasColors.black,
  }) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      title: TextComponent(
        value: title,
        fontWeight: FontWeight.w600,
        fontColor: textColor,
        fontSize: MahasFontSize.h5,
      ),
      elevation: 0,
      centerTitle: false,
      leading: leading,
      actions: actions,
    );
  }

  static Widget bannerInfoWidget({
    required IconData icon,
    required String title,
    required Color color,
    Color? fontColor,
    double? radius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius ?? MahasRadius.regular),
      ),
      child: ListTile(
        horizontalTitleGap: 5,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(icon, size: 40, color: color),
        title: TextComponent(
          value: title,
          fontSize: MahasFontSize.small,
          fontColor: fontColor ?? MahasColors.black,
        ),
      ),
    );
  }

  static Future<bool?> dialogConfirmation({
    String? title,
    String? message,
    IconData? icon,
    Widget? content,
    String? textConfirm,
    String? textCancel,
    bool isWithBatal = false,
    bool barrierDissmisible = true,
    bool onlyShowConfirm = false,
    Color? iconColor,
  }) async {
    return await Get.dialog<bool?>(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.back(result: false);
        },
        child: AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          actionsPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: icon != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Icon(icon, size: 100, color: iconColor),
                ),
              ),
              Visibility(
                visible: title != null,
                child: Column(
                  children: [
                    TextComponent(
                      value: title ?? "",
                      fontSize: MahasFontSize.h6,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Visibility(
                visible: message != null,
                child: TextComponent(
                  value: message,
                  textAlign: TextAlign.center,
                  fontWeight: title != null ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
              Visibility(
                visible: content != null,
                child: content ?? Container(),
              ),
            ],
          ),
          actions: [
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
                child:
                    onlyShowConfirm
                        ? ButtonComponent(
                          text: textConfirm ?? "submit".tr,
                          isMultilineText: true,
                          borderRadius: MahasRadius.small,
                          onTap: () {
                            Get.back(result: true);
                          },
                        )
                        : isWithBatal
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              child: ButtonComponent(
                                text: textConfirm ?? "submit".tr,
                                isMultilineText: true,
                                onTap: () {
                                  Get.back(result: true);
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Flexible(
                              child: ButtonComponent(
                                text: textCancel ?? "batal".tr,
                                isMultilineText: true,
                                borderColor: MahasColors.grayText,
                                btnColor: MahasColors.white,
                                textColor: MahasColors.black,
                                borderRadius: MahasRadius.small,
                                onTap: () {
                                  Get.back(result: false);
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Flexible(
                              child: ButtonComponent(
                                text: "batal".tr,
                                isMultilineText: true,
                                borderColor: MahasColors.grayText,
                                btnColor: MahasColors.white,
                                textColor: MahasColors.black,
                                borderRadius: MahasRadius.small,
                                onTap: Get.back,
                              ),
                            ),
                          ],
                        )
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              child: ButtonComponent(
                                text: textCancel ?? "batal".tr,
                                isMultilineText: true,
                                borderColor: MahasColors.grayText,
                                btnColor: MahasColors.white,
                                textColor: MahasColors.black,
                                borderRadius: MahasRadius.small,
                                onTap: () {
                                  Get.back(result: false);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: ButtonComponent(
                                text: textConfirm ?? "submit".tr,
                                borderRadius: MahasRadius.small,
                                isMultilineText: true,
                                onTap: () {
                                  Get.back(result: true);
                                },
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDissmisible,
    );
  }

  static Future<bool> dialogWarning(
    String? message, {
    showButton = false,
    String? text,
    Function()? function,
    bool barrierDissmisible = true,
  }) async {
    return await Get.dialog(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.back(result: true);
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
          ),
          backgroundColor: MahasColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: MahasColors.red,
                size: 60,
              ),
              const Padding(padding: EdgeInsets.all(7)),
              Text(
                textAlign: TextAlign.center,
                message ?? "-",
                style: const TextStyle(color: MahasColors.black),
              ),
              showButton
                  ? Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ButtonComponent(
                      onTap: function!,
                      text: text ?? "ok".tr,
                    ),
                  )
                  : SizedBox(),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDissmisible,
    );
  }

  static Future<bool> dialogWithWidget({
    showButton = false,
    required List<Widget> children,
    String? textConfirm,
    String? textCancel,
    Function()? confirmFunction,
    Function()? cancelFunction,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) async {
    return await Get.dialog(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.back(result: true);
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
          ),
          backgroundColor: MahasColors.white,
          content: Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...children,
              SizedBox(height: 20),
              Row(
                children: [
                  if (cancelFunction != null) ...[
                    SizedBox(width: 15),
                    Expanded(
                      child: ButtonComponent(
                        onTap: cancelFunction,
                        text: textCancel ?? "cancel".tr,
                        textColor: MahasColors.red,
                        borderColor: MahasColors.red,
                        btnColor: MahasColors.white,
                      ),
                    ),
                  ],
                  if (confirmFunction != null) ...[
                    Expanded(
                      child: ButtonComponent(
                        onTap: confirmFunction,
                        text: textConfirm ?? "ok".tr,
                        textColor: MahasColors.darkBlue,
                        borderColor: MahasColors.darkBlue,
                        btnColor: MahasColors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool> dialogSuccess({String? message, String? title}) async {
    return await Get.dialog(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.back(result: true);
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
          ),
          backgroundColor: MahasColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: MahasColors.darkBlue,
                size: 60,
              ),
              const Padding(padding: EdgeInsets.all(7)),
              Visibility(
                visible: title != null && title != "",
                child: TextComponent(
                  textAlign: TextAlign.center,
                  value: title ?? "",
                  fontSize: MahasFontSize.h6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Visibility(
                visible: message != null && message != "",
                child: TextComponent(
                  textAlign: TextAlign.center,
                  value: message ?? "",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> notifBottomSheet({
    required String subtitle,
    List<Widget>? children,
    String? title,
    NotifType notifType = NotifType.warning,
  }) {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
    return Get.bottomSheet<bool>(
      enableDrag: false,
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.back(result: false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: MahasColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextComponent(
                      value:
                          title ??
                          (notifType == NotifType.success
                              ? "success".tr
                              : "error".tr),
                      fontWeight: FontWeight.w600,
                      fontSize: MahasFontSize.h6,
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 40,
                      child: GestureDetector(
                        onTap: () => Get.back(result: false),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: MahasColors.black.withValues(alpha: 0.06),
                          ),
                          child: Icon(Icons.close, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      ImageComponent(
                        localUrl:
                            notifType == NotifType.warning
                                ? "assets/images/error.png"
                                : "assets/images/success.png",
                        height: 150,
                        width: Get.width,
                        boxFit: BoxFit.fitHeight,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      TextComponent(
                        value: subtitle,
                        textAlign: TextAlign.center,
                      ),
                      if (children != null) ...children,
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<bool?> confirmationBottomSheet({
    required List<Widget> children,
    String? title,
    String? textConfirm,
    String? textCancel,
    Color confirmColor = MahasColors.primary,
    bool withImage = false,
  }) {
    return Get.bottomSheet<bool>(
      enableDrag: false,
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.back(result: false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: MahasColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextComponent(
                      value: title ?? "",
                      fontWeight: FontWeight.w600,
                      fontSize: MahasFontSize.h6,
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 40,
                      child: GestureDetector(
                        onTap: () => Get.back(result: false),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: MahasColors.black.withValues(alpha: 0.06),
                          ),
                          child: Icon(Icons.close, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      withImage
                          ? Center(
                            child: ImageComponent(
                              localUrl: "assets/images/question.png",
                              height: 150,
                              width: Get.width,
                              boxFit: BoxFit.fitHeight,
                              margin: EdgeInsets.only(bottom: 20),
                            ),
                          )
                          : SizedBox(height: 15),

                      ...children,
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 20,
                        children: [
                          Expanded(
                            child: ButtonComponent(
                              text: textCancel ?? "cancel".tr,
                              isMultilineText: true,
                              borderColor: MahasColors.grayText,
                              btnColor: MahasColors.white,
                              textColor: MahasColors.black,
                              borderRadius: MahasRadius.regular,
                              onTap: () {
                                Get.back(result: false);
                              },
                            ),
                          ),
                          Expanded(
                            child: ButtonComponent(
                              text: textConfirm ?? "ok".tr,
                              borderRadius: MahasRadius.regular,
                              btnColor: confirmColor,
                              isMultilineText: true,
                              onTap: () {
                                Get.back(result: true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget carouselWidget({required List<ArticleModel> imageList}) {
    return CarouselSlider(
      items:
          imageList.map((item) {
            return Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MahasColors.black.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(MahasRadius.large),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  image: NetworkImage(item.imageUrl),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, MahasColors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(MahasRadius.large),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextComponent(
                        value: item.title,
                        fontColor: MahasColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: MahasFontSize.h6,
                      ),
                      TextComponent(
                        value: item.subtitle,
                        fontColor: MahasColors.white,

                        fontSize: MahasFontSize.small,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
      options: CarouselOptions(
        height: Get.width * 0.8,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  static Widget listLoadingWidget({required int count, double? height}) {
    return Shimmer.fromColors(
      baseColor: MahasColors.mediumgray,
      highlightColor: MahasColors.lightgray,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder:
            (context, index) => Container(
              decoration: BoxDecoration(
                color: MahasColors.white,
                borderRadius: BorderRadius.circular(MahasRadius.regular),
              ),
              height: height ?? 80,
            ),
      ),
    );
  }

  static Widget generalPopScopeWidget({
    required Widget child,
    required bool Function() showConfirmationCondition,
    Function()? customBackAction,
  }) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (showConfirmationCondition()) {
          bool? result = await ReusableWidgets.confirmationBottomSheet(
            textConfirm: "yes".tr,
            withImage: true,
            children: [TextComponent(value: "go_back_confirmation".tr)],
          );
          if (result == true) {
            customBackAction ?? Get.back();
          }
        } else {
          Get.back();
        }
      },
      child: child,
    );
  }
}
