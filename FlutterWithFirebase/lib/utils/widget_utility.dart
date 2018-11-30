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

  static Widget buildPadding(Widget childWidget, double left, double right,
      double top, double bottom) {
    return Padding(
        padding:
            EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
        child: childWidget);
  }

  static Color getGlobalScreenBgColor() {
    return Colors.black12;
  }

  static TextStyle getTitleStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headline
        .copyWith(color: Colors.deepPurple);
  }

  static TextStyle getSubTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.subhead;
  }

  static TextStyle getButtonLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold);
  }
}
