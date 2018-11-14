import 'package:flutter/material.dart';

import 'StatefulWidgetDemo.dart';
import 'StatelessWidgetDemo.dart';

var myWidget = Home();
//var myWidget = MyStatefulWidget();
//var myWidget = MyStatelessWidget(new Text("Global Text"));
void main() => runApp(myWidget);

class Home extends StatefulWidget {
  @override
  State createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Home Title",
        home: Scaffold(
            appBar: AppBar(title: Text("Home")),
            body: Checkbox(
                value: isChecked,
                onChanged: (bool newValue) {
                  setState(() {
                    isChecked = newValue;
                    if (isChecked) {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        MyStatelessWidget(Text("some text"));
                      }));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        MyStatefulWidget();
                      }));
                    }
                  });
                })));
  }
}
