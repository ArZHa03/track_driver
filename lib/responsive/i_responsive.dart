import 'package:flutter/material.dart';

abstract class IResponsive {
  double hp(double size);
  double wp(double size);
  double sp(double size);

  Text text(
    String text, {
    double fontSize = 12,
    Color color = Colors.black,
    int? maxLines,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    TextStyle? textStyle,
  });

  TextStyle textStyle({
    double fontSize = 12,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w400,
    TextStyle? textStyle,
  });

  Widget loading();
}
