import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

Color getRandomColor() {
  return Colors.primaries[Random().nextInt(Colors.accents.length)]
      .withBlue(50)
      .withRed(100);
}
