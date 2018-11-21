import 'package:flutter/material.dart';
import 'dart:async';

class AccSplashScreen extends StatefulWidget {
  @override
  State createState() {
    return AccSplashState();
  }
}

class AccSplashState extends State<AccSplashScreen> {
  static final String _title = "Splash Screen";

  @override
  Widget build(BuildContext context) {
    MaterialApp materialApp = MaterialApp(
        title: "splash screen",
        theme: ThemeData(primarySwatch: Colors.green),
        home: Scaffold(body: getBodyWidget()));

    return materialApp;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getBodyWidget() {
    return Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: Colors.green, shape: BoxShape.rectangle),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          GestureDetector(child:
          Image.asset(
            "assets/accenture_logo.png",
            fit: BoxFit.fill,
          ),onTap:()=> startATimer(5,context)),
          /*Text(
          "Loading....Please Wait",
          style: TextStyle(color: Colors.white),
        )*/
        ]));
  }

  void startATimer(int secs, context1) {
    Duration duration = new Duration(seconds: 1);
    Timer.periodic(duration, (Timer timer) {
      if (secs <= 0) {
        timer.cancel();
        MaterialPageRoute nextPage =
            MaterialPageRoute(builder: (context) => Container());
        Navigator.of(context).push(nextPage);
      } else {
        secs--;
      }
    });
  }
}
