import 'package:flutter/material.dart';

extension SizeExtension on BuildContext {
  double wp(double pixel) =>
      MediaQuery.of(this).size.width * (pixel / MediaQuery.of(this).size.width);

  double hp(double pixel) =>
      MediaQuery.of(this).size.height *
      (pixel / MediaQuery.of(this).size.height);
}
