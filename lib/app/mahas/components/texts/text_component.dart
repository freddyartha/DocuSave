import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:flutter/material.dart';

class TextComponent extends StatelessWidget {
  final String? value;
  final Color fontColor;
  final FontWeight fontWeight;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool isMuted;
  final TextAlign textAlign;
  final int? maxLines;
  final Function()? onTap;
  final EdgeInsetsGeometry margin;
  final double? height;
  final Color? underlineColor;
  final FontStyle? fontStyle;
  const TextComponent({
    super.key,
    @required this.value,
    this.fontColor = MahasColors.black,
    this.onTap,
    this.isMuted = false,
    this.fontWeight = FontWeight.normal,
    this.fontSize = MahasFontSize.normal,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.height,
    this.underlineColor,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Text(
            value!,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: fontColor.withValues(alpha: isMuted ? .9 : 1),
              height: height,
              decoration:
                  underlineColor == null ? null : TextDecoration.underline,
              decorationColor: underlineColor,
              decorationThickness: 2,
              fontStyle: fontStyle,
            ),

            textAlign: textAlign,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
          ),
        ),
      ),
    );
  }
}
