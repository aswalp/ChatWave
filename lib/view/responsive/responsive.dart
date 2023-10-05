import 'package:flutter/material.dart';

class Responsive {
  static double h(double height, BuildContext context) {
    return MediaQuery.sizeOf(context).height * (height / 780);
  }

  static double w(double width, BuildContext context) {
    return MediaQuery.sizeOf(context).width * (width / 360);
  }
}
