import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  @override
  State createState() {
    return new MyStatefulWidgetState();
  }
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool checkBoxValue = false;
  //every time the state changes, call this method
  @override
  Widget build(BuildContext context) {
    var materialApp = new MaterialApp(
        title: "Hello Stateful",
        home: new Scaffold(
            appBar: new AppBar(title: new Text("Stateful Title Goes here")),
            body: new Center(
                child: new Checkbox(
                    value: checkBoxValue,
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxValue = newValue;
                      });
                    }))));
    return materialApp;
  }
}
