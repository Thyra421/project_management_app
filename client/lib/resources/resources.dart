import 'package:flutter/material.dart';

class Resources {
  static Image logo({Color? color, double? width, double? height}) =>
      Image.asset(
        'assets/images/logo.png',
        color: color,
        width: width,
        height: height,
      );

  static Image illustration({
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
  }) =>
      Image.asset(
        'assets/images/illustration.png',
        fit: fit,
        width: width,
        height: height,
      );
}
