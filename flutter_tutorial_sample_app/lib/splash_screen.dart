import 'package:flutter/material.dart';

class AccSplashScreen extends StatefulWidget {
  @override
  State createState() {}
}

class AccSplashState extends State<AccSplashScreen> {
  static final String _title = "Splash Screen";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "splash screen",
        home: Scaffold(
            appBar: AppBar(title: Text(_title)), body: getBodyWidget()));
  }
}

Widget getBodyWidget() {
  return Container(
      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.rectangle),
      child: Text(
        "Loading....Pls wait",
        style: TextStyle(color: Colors.white),
      ));
}
