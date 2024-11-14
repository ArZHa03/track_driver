import 'i_responsive.dart';
import 'package:flutter/material.dart';

class Responsive implements IResponsive {
  final BuildContext _context;

  final double _referenceWidth = 360;
  final double _referenceHeight = 640;

  Size? _physicalSize;
  double? _screenWidth;
  double? _screenHeight;
  Responsive(this._context);

  double _getResponsiveSize(double size, {required bool isWidth}) {
    _setAttributes();
    final referenceSize = isWidth ? _referenceWidth : _referenceHeight;
    final screenSize = isWidth ? _screenWidth : _screenHeight;

    final referenceAspectRatio = _referenceWidth / _referenceHeight;
    final screenAspectRatio = _screenWidth! / _screenHeight!;

    if (screenAspectRatio > referenceAspectRatio && _screenHeight! > _referenceHeight) {
      final widthRatio = _screenWidth! / _referenceWidth;
      final heightRatio = _screenHeight! / _referenceHeight;
      return size * (widthRatio < heightRatio ? widthRatio : heightRatio);
    } else if (screenAspectRatio > referenceAspectRatio) {
      return size * (screenSize! / referenceSize) * (referenceAspectRatio / screenAspectRatio);
    } else if (screenAspectRatio < referenceAspectRatio) {
      return size * (screenSize! / referenceSize) * (screenAspectRatio / referenceAspectRatio);
    }
    return size * (screenSize! / referenceSize);
  }

  void _setAttributes() {
    _physicalSize = MediaQuery.of(_context).size;
    _screenWidth = _physicalSize!.width;
    _screenHeight = _physicalSize!.height;
  }

  @override
  double hp(double size) => _getResponsiveSize(size, isWidth: false);

  @override
  double wp(double size) => _getResponsiveSize(size, isWidth: true);

  @override
  double sp(double size) => _getResponsiveSize(size, isWidth: false);

  @override
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
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: sp(fontSize),
        fontWeight: fontWeight,
        color: color,
      ).merge(textStyle),
      textScaler: TextScaler.noScaling,
      maxLines: maxLines,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
    );
  }

  @override
  TextStyle textStyle({
    double fontSize = 12,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w400,
    TextStyle? textStyle,
  }) {
    return TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: sp(fontSize),
      fontWeight: fontWeight,
      color: color,
    ).merge(textStyle);
  }

  @override
  Widget loading() {
    return Center(child: Image.asset('assets/images/loading_app.gif', width: wp(125), fit: BoxFit.contain));
  }
}
