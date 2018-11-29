import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelloCircular extends StatefulWidget {
  @override
  State createState() {
    return CircularState();
  }
}

class CircularState extends State<HelloCircular> {
  bool showProgress = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Hello ProgressBar")),
        body: Column(children: <Widget>[
          getWidget(),
          GestureDetector(onTap:()=> showFlutterToast("HELLO GESTER...Tapped"),
          child:Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.album),
                  title: Text('MLKit Text Recognition'),
                  subtitle: Text('Scan business card & extract text. Edit & save.'),
                ),
                ButtonTheme.bar( // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('SCAN NEW'),
                        onPressed: () { /* ... */ },
                      ),
                      FlatButton(
                        child: const Text('VIEW SAVED'),
                        onPressed: () { /* ... */ },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
         RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text("ShowProgressBar"),
                onPressed: () => switchProgress(),
              ),
        ]));
  }

  switchProgress() {
    setState(() {
      if (showProgress) {
        showProgress = false;
      } else {
        showProgress = true;
      }
    });
  }

  Widget getWidget() {
    return showProgress
        ? CircularProgressIndicator()
        : Text("Progress bar dismissed");
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
}
