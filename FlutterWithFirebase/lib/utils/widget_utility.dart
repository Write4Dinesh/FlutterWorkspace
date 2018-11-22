import 'package:flutter/material.dart';

class WidgetUtility {
  static RoundedRectangleBorder getShape(borderRadius) {
    return RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(borderRadius));
  }
}
