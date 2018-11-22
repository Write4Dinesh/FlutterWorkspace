import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutfire/acc_home.dart';
import 'dart:async';
import 'utils/acc_app_constants.dart' as AppConstants;

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
      title: AppConstants.APP_NAME,
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: <String, WidgetBuilder>{
        AppConstants.SCREEN_NAME_SPLASH: (BuildContext context) =>
            AccSplashScreen(),
        AppConstants.SCREEN_NAME_HOME: (BuildContext context) => AccHome()
      },
      navigatorObservers: <NavigatorObserver>[observer],
      // home: new WallScreen(analytics: analytics, observer: observer),
      home: AppConstants.firstLaunch ? AccSplashScreen() : AccHome(),
    );
  }
}

class AccSplashScreen extends StatefulWidget {
  AccSplashScreen() {
    AppConstants.firstLaunch = false;
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
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                    "assets/accenture_logo.png",
                    fit: BoxFit.fill,
                  ),
                  onTap: () => goToHomeScreen(1, context)),
              Padding(padding: EdgeInsets.only(top:200.0), child:Text("Flutter For Accenture",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold))),

            ]));
    goToHomeScreen(3, context);
    return container;
  }

  void goToHomeScreen(int delayInSecs, context1) {
    Duration duration = new Duration(seconds: 1);
    Timer.periodic(duration, (Timer timer) {
      if (delayInSecs <= 0) {
        timer.cancel();
        NavigatorState navigatorState = Navigator.of(context1);
        navigatorState.popAndPushNamed(AppConstants.SCREEN_NAME_HOME);
      } else {
        delayInSecs--;
      }
    });
  }
}
