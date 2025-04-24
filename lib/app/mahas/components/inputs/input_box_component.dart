import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

class InputBoxComponent extends StatelessWidget {
  final String? label;
  final double? marginBottom;
  final String? childText;
  final Widget? children;
  final Widget? childrenSizeBox;
  final GestureTapCallback? onTap;
  final bool alowClear;
  final String? errorMessage;
  final IconData? icon;
  final bool? isRequired;
  final bool? editable;
  final Function()? clearOnTab;
  final Color? labelColor;
  final Radius? borderRadius;

  const InputBoxComponent({
    super.key,
    this.label,
    this.marginBottom,
    this.childText,
    this.onTap,
    this.children,
    this.childrenSizeBox,
    this.alowClear = false,
    this.clearOnTab,
    this.errorMessage,
    this.isRequired = false,
    this.icon,
    this.editable,
    this.labelColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: label != null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                TextComponent(
                  value: label ?? '-',
                  fontSize: MahasFontSize.h6,
                  fontWeight: FontWeight.w500,
                ),
                Visibility(
                  visible: isRequired == true,
                  child: TextComponent(
                    value: "*",
                    fontSize: MahasFontSize.h6,
                    fontWeight: FontWeight.w500,
                    fontColor: MahasColors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: children == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      borderRadius == null
                          ? MahasRadius.regular
                          : borderRadius!.x,
                    ),
                    color:
                        editable == true
                            ? MahasColors.lightgray
                            : MahasColors.mediumgray,
                    border:
                        errorMessage != null
                            ? Border.all(
                              color: MahasColors.red.withValues(alpha: .5),
                            )
                            : Border.all(color: MahasColors.mutedGrey),
                  ),
                  padding:
                      childrenSizeBox != null
                          ? null
                          : const EdgeInsets.only(left: 10, right: 10),
                  child:
                      childrenSizeBox ??
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: onTap,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextComponent(
                                  value: childText ?? '',
                                  fontSize: MahasFontSize.normal,
                                  fontColor: MahasColors.black,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: alowClear,
                            child: SizedBox(
                              width: 20,
                              height: 30,
                              child: InkWell(
                                onTap: clearOnTab,
                                child: const Icon(Icons.close, size: 14),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !alowClear && icon != null,
                            child: SizedBox(
                              width: 20,
                              height: 30,
                              child: InkWell(
                                onTap: onTap,
                                child: Icon(icon, size: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
              ),
              Visibility(
                visible: errorMessage != null,
                child: TextComponent(
                  value: errorMessage ?? "",
                  fontSize: MahasFontSize.small,
                  fontColor: MahasColors.red,
                  padding: const EdgeInsets.only(left: 12),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: children != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              children ?? Container(),
              Visibility(
                visible: errorMessage != null,
                child: TextComponent(
                  value: errorMessage ?? "",
                  fontSize: MahasFontSize.small,
                  fontColor: MahasColors.red,
                  padding: const EdgeInsets.only(left: 12),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: marginBottom ?? 10),
      ],
    );
  }
}
