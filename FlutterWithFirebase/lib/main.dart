import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutfire/acc_home.dart';
import 'dart:async';
import 'utils/acc_app_constants.dart' as AccConstants;

void main() => runApp(new MyApp());
//void main() => runApp(AccSplashScreen());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      new FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelloFireML',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      // home: new WallScreen(analytics: analytics, observer: observer),
      home: AccConstants.firstLaunch ? AccSplashScreen() : AccHome(),
    );
  }
}

class AccSplashScreen extends StatefulWidget {
  AccSplashScreen() {
    AccConstants.firstLaunch = false;
  }

  @override
  State createState() {
    return AccSplashState();
  }
}

class AccSplashState extends State<AccSplashScreen> {
  static final String _title = "Splash Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBodyWidget(context));
  }

  Widget getBodyWidget(BuildContext context) {
    var container = Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: Colors.green, shape: BoxShape.rectangle),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          GestureDetector(
              child: Image.asset(
                "assets/accenture_logo.png",
                fit: BoxFit.fill,
              ),
              onTap: () => startATimer(5, context)),
          /*Text(
          "Loading....Please Wait",
          style: TextStyle(color: Colors.white),
        )*/
        ]));
    startATimer(5, context);
    return container;
  }

  void startATimer(int secs, context1) {
    Duration duration = new Duration(seconds: 1);
    Timer.periodic(duration, (Timer timer) {
      if (secs <= 0) {
        timer.cancel();
        MaterialPageRoute nextPage =
            MaterialPageRoute(builder: (context) => AccHome());
        Navigator.of(context1).push(nextPage);
      } else {
        secs--;
      }
    });
  }
}
