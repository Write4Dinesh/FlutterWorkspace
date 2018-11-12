import 'package:flutter/material.dart';

class MyCustomList extends Container {
  @override
  Widget build(BuildContext context) {
    print("Helooooooo");
    return MaterialApp(
        title: "hello material",
        home: Scaffold(
            appBar: AppBar(title: Text("Hello")), body: Text("Hil...")));
  }

}
