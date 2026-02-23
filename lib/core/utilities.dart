

import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';

Widget buildStars(double value, {double size = 20}) {
  List<Widget> stars = [];
  for (int i = 1; i <= 5; i++) {
    if (value >= i) {
      stars.add(Icon(Icons.star, color: UhoColor.highlight, size: size));
    } else if (value > i - 1 && value < i) {
      stars.add(Icon(Icons.star_half, color: UhoColor.highlight, size: size));
    } else {
      stars.add(Icon(Icons.star_border, color: UhoColor.background, size: size));
    }
  }
  return Row(children: stars);
}