import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mlkit/mlkit.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/view/business_card/acc_view_businesscard.dart';
import 'package:flutfire/data/business_card/acc_businesscard_data_helper.dart';

class AccShowBusinessCardList extends StatefulWidget {
  AccShowBusinessCardList();

  @override
  State<StatefulWidget> createState() {
    return ShowBusinessCardListState();
  }
}

class ShowBusinessCardListState extends State<AccShowBusinessCardList>
    with WidgetsBindingObserver {
  static const String KeySeparator = "~";
  static const String CARD_FIELD_SEPARATOR = "|";
  static const String LIST_OF_KEYS = "list_of_keys";
  final myController = TextEditingController();
  bool detailsScreenLaunched = false;
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;

  List<String> _allKeys = <String>[];

  Stream sub;
  StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    fetchData();
  }

  void fetchData() async {
    _allKeys = await AccBusinessCardDataHelper.loadAllKeys();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppConstants.BUSINESS_CARD_SCANNER_SCREEN_TITLE),
        ),
        body: Column(
          children: <Widget>[
            buildTextList(_allKeys),
          ],
        ));
  }

  Widget buildTextList(List<String> texts) {
    if (texts.length == 0) {
      return Expanded(
          flex: 1,
          child: Center(
            child: Text('The List is empty.',
                style: Theme.of(context).textTheme.subhead),
          ));
    }
    return Expanded(
        flex: 1,
        child: Container(
          color: Colors.black12,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              itemCount: texts.length,
              itemBuilder: (context, i) {
                return getCardItem(texts[i]);
              }),
        ));
  }

  goToNextScreen(String text) async {
    String bcard = await AccBusinessCardDataHelper.loadBusinessCardByKey(text);
    detailsScreenLaunched = true;
    MaterialPageRoute<bool> route = MaterialPageRoute(
        builder: (context) => AccViewBusinessCard(bcard, text));
    Navigator.of(context).push(route);
  }

  getStringArray() {
    List<String> arr = <String>[];
    for (int i = 0; i < _allKeys.length; i++) {
      arr.add(_allKeys[i]);
    }
    return arr;
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }

//only called when we move this screen to background..not when navigated to next screen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && detailsScreenLaunched) {
      detailsScreenLaunched = false;
      setState(() {});
    } else if (state == AppLifecycleState.paused) {}
  }

  Widget getCardItem(String title) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              trailing: Icon(Icons.arrow_right),
              title: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.deepPurpleAccent)),
              onTap: () => goToNextScreen(title)),
        ],
      ),
    );
  }
}
