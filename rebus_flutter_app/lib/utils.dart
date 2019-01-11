import 'package:flutter/material.dart';

class Util {
  const Util();

  double _screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double _screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
