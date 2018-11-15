import 'package:flutter/material.dart'; //used package to mark package manager pub gets it

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Screen1",
        home: Scaffold(
            appBar: AppBar(title: Center(child: Text("Screen1"))),
            body: Column(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                      child: Row(
                        children: <Widget>[
                          Image.asset('assets/back.png'),
                          Padding(padding: EdgeInsets.only(left: 150.0)),
                          Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: getFontStyleForSettings(),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ))),
              Expanded(
                  flex: 7,
                  child: Column(children: <Widget>[
                    Text("Middle1"),
                    Text("Middle2"),
                    Text("Middle3")
                  ])),
              Expanded(
                  flex: 2,
                  child: Container(
                      child: Row(children: <Widget>[
                      Container(child:Column(
                          children: <Widget>[
                            getBottomImage("assets/back.png"),
                            Text("Home", style: getFontStyleForBottomText())
                          ],

                        )),
                        Container(child:Column(
                          children: <Widget>[
                            getBottomImage("assets/settings.png"),
                            Text("Settings", style: getFontStyleForBottomText())
                          ],
                        )),
            Container(child:Column(children: <Widget>[
                          getBottomImage("assets/share.png"),
                          Text("Share", style: getFontStyleForBottomText())
                        ]))
                      ]),
                      color: Colors.blue))
            ])));
  }

  TextStyle getFontStyleForSettings() {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold);
  }

  TextStyle getFontStyleForBottomText() {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 10,
        color: Colors.grey,
        fontWeight: FontWeight.bold);
  }

  Image getBottomImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.fill,
    );
  }
}
