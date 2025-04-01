import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonComponent extends StatefulWidget {
  final Function() onTap;
  final String text;
  final Color textColor;
  final Color? btnColor;
  final FontWeight fontWeight;
  final double fontSize;
  final double borderRadius;
  final double? width;
  final bool isMultilineText;
  final String? icon;
  final bool isSvg;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final Widget? trailing;
  final Widget? leading;

  const ButtonComponent({
    super.key,
    required this.onTap,
    required this.text,
    this.textColor = MahasColors.white,
    this.btnColor = MahasColors.primary,
    this.fontWeight = FontWeight.normal,
    this.fontSize = MahasFontSize.h6,
    this.borderColor = Colors.transparent,
    this.width,
    this.isMultilineText = false,
    this.icon,
    this.isSvg = true,
    this.borderRadius = MahasRadius.regular,
    this.padding,
    this.iconSize,
    this.trailing,
    this.leading,
  });

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? double.infinity,
        padding: widget.padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: widget.borderColor),
          color: widget.btnColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon != null
                ? widget.isSvg
                    ? SvgPicture.asset(
                      widget.icon!,
                      width: widget.iconSize ?? 15,
                      colorFilter: ColorFilter.mode(
                        widget.textColor,
                        BlendMode.srcIn,
                      ),
                    )
                    : Image(
                      image: AssetImage(widget.icon!),
                      width: widget.iconSize ?? 15,
                    )
                : SizedBox(),
            if (widget.leading != null) ...[
              widget.leading!,
              SizedBox(width: 5),
            ],
            Flexible(
              flex: widget.isMultilineText ? 1 : 0,
              child: TextComponent(
                value: widget.text,
                fontColor: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                textAlign: TextAlign.center,
                margin:
                    widget.icon != null
                        ? const EdgeInsets.only(left: 10)
                        : EdgeInsets.zero,
              ),
            ),
            if (widget.trailing != null) ...[
              SizedBox(width: 5),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
