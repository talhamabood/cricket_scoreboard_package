import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final Color? color;
  final double? fontSize;
  final int? maxLines;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final TextDirection? textDirection;
  final Color? decorationColor;
  const CustomTextWidget(
      {super.key,
      required this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.fontStyle,
      this.textOverflow,
      this.textDecoration,
      this.decorationColor, this.fontFamily, this.maxLines, this.textDirection});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: true,
      textDirection: textDirection,
      style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontStyle: fontStyle,
          decoration: textDecoration,

          decorationColor: decorationColor,
        fontFamily: fontFamily
        ),
    );
  }
}
