import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WidgetUtility {
  static RoundedRectangleBorder getShape(borderRadius) {
    return RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(borderRadius));
  }

  ///
  /// not working
  ///
  static showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text(message),
    ));
  }

  static showFlutterToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        bgcolor: Colors.green.toString(),
        textcolor: Colors.white.toString());
  }

  static Stack getStackWithProgressbar(Widget body, bool toBeShownProgressbar) {
    List<Widget> children = <Widget>[];
    children.add(body);
    if (toBeShownProgressbar) {
      children.add(CircularProgressIndicator());
    }
    return Stack(alignment: AlignmentDirectional.center, children: children);
  }
}
