import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextItem {
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? fontColor;
  final Color? underlineColor;
  final Function()? onTap;

  RichTextItem({
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.fontSize = MahasFontSize.normal,
    this.fontColor = MahasColors.black,
    this.underlineColor,
    this.onTap,
  });
}

class RichTextComponent extends StatelessWidget {
  final List<RichTextItem> teks;
  final EdgeInsetsGeometry margin;
  final TextAlign textAlign;
  const RichTextComponent({
    super.key,
    required this.teks,
    this.textAlign = TextAlign.left,
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text.rich(
        textAlign: textAlign,
        TextSpan(
          children:
              teks
                  .map(
                    (e) => TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = e.onTap,
                      text: e.text,
                      style: TextStyle(
                        fontSize: e.fontSize,
                        fontWeight: e.fontWeight,
                        color: e.fontColor,
                        decoration:
                            e.underlineColor == null
                                ? null
                                : TextDecoration.underline,
                        decorationColor: e.underlineColor,
                        decorationThickness: 2,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
