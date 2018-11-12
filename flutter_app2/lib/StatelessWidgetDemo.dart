import 'package:flutter/material.dart';
class MyStatelessWidget extends StatelessWidget {
  final Widget textWidget;

  MyStatelessWidget(this.textWidget);

  @override
  Widget build(BuildContext context) {
    var materialApp = new MaterialApp(
        title: "FirstScreen",
        home: new Scaffold(
            appBar: new AppBar(title: new Text("First Screen")),
            body: new FirstScreenBodyWidget(textWidget)));
    return materialApp;
  }
}

class FirstScreenBodyWidget extends StatelessWidget {
  final Widget globalTextWidget;

  FirstScreenBodyWidget(this.globalTextWidget);

  @override
  Widget build(BuildContext context) {
    bool checkBoxValue = true;
    return new Center(
        child: new Row(children: <Widget>[
          new Text("Hello First Screen1"),
          new Text("Hello First Screen2"),
          globalTextWidget,
          new Checkbox(
              value:checkBoxValue,
              onChanged: (bool newValue) {checkBoxValue = newValue;})
        ]));
  }
}