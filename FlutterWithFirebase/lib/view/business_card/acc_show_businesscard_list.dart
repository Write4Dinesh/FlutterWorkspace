import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mlkit/mlkit.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/utils/widget_utility.dart';
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
            child: Text('No text detected',
                style: Theme.of(context).textTheme.subhead),
          ));
    }
    return Expanded(
        flex: 1,
        child: Container(
          child: ListView.builder(
              padding: const EdgeInsets.all(1.0),
              itemCount: texts.length,
              itemBuilder: (context, i) {
                return _buildListItem(texts[i]);
              }),
        ));
  }

  Widget _buildListItem(text) {
    return ListTile(
      title: Text(
        "$text",
      ),
      onTap: () => goToNextScreen(text),
      dense: true,
    );
  }

  goToNextScreen(String text) async {
    WidgetUtility.showFlutterToast(text);
    String bcard = await AccBusinessCardDataHelper.loadBusinessCardByKey(text);
    detailsScreenLaunched = true;
    MaterialPageRoute<bool> route = MaterialPageRoute(
        builder: (context) => AccViewBusinessCard(bcard, text));
    Future<bool> onNextScreenPoppedOff = Navigator.of(context).push(route);
    onNextScreenPoppedOff.then((returnedFromDetailScreen) {
      if (returnedFromDetailScreen) {
        WidgetUtility.showFlutterToast("Navigated back");
      }
    });
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
}
