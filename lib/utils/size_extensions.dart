import 'package:flutter/material.dart';

extension SizeExtension on BuildContext {
  double wp(double pixel) => pixel / MediaQuery.of(this).size.width;

  double hp(double pixel) => pixel / MediaQuery.of(this).size.height;
}
