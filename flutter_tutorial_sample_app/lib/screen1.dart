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
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image.asset('assets/back.png'),
                          Padding(padding: EdgeInsets.only(left: 150.0)),
                          Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: buildTextStyleForTopBar(),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ))),
              Expanded(flex: 7, child: buildListView()),
              Expanded(flex: 1, child: buildBottomBar())
            ])));
  }

  ListView buildListView() {
    const listSize = 100;
    var widgetArray = <Widget>[];
    for (int i = 0; i < listSize; i++) {
      widgetArray.add(Container(
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          padding: EdgeInsets.all(10.0),
          child: Text("ListItem_$i")));
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => widgetArray[index],
      itemCount: widgetArray.length,
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
    );
  }

  Container buildBottomBar() {
    return Container(
      color: Colors.blue,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getBottomImage("assets/home.png"),
                Text("Home", style: buildTextStyleForBottomBar())
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getBottomImage("assets/settings.png"),
                Text("Settings", style: buildTextStyleForBottomBar())
              ],
            ),
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getBottomImage("assets/share.png"),
                  Text("Share", style: buildTextStyleForBottomBar())
                ])
          ]),
    );
  }

  TextStyle buildTextStyleForTopBar() {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 30.0,
        color: Colors.white,
        fontWeight: FontWeight.bold);
  }

  TextStyle buildTextStyleForBottomBar() {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 10.0,
        color: Colors.grey,
        fontWeight: FontWeight.bold);
  }

  Image getBottomImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.fill,
      height: 50.0,
      width: 50.0,
    );
  }
}
