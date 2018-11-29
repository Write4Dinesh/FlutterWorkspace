import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:mlkit/mlkit.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/utils/widget_utility.dart';
import 'package:flutfire/data/acc_businesscard_data_helper.dart';

class AccBusinessCardScanDetail extends StatefulWidget {
  static final int MODE_EDIT = 1;
  static final int MODE_SCAN_NEW = 2;
  final File _file;
  int _mode;
  String _bcString;
  String _key;

  AccBusinessCardScanDetail(this._file, this._mode, this._bcString, this._key);

  @override
  State<StatefulWidget> createState() {
    return _AccScanDetailState();
  }
}

class _AccScanDetailState extends State<AccBusinessCardScanDetail> {
  static const String LABEL_SAVE = "Save";
  final saveTFieldContrlr = TextEditingController();
  final bcTFieldContrlr = TextEditingController();

  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;

  bool _showProgress = false;
  String _multilineBc = "";
  String _bcTitle = "";

  Stream sub;
  StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    sub = new Stream.empty();
    subscription = sub.listen((_) => _getImageSize)..onDone(analyzeLabels);
  }

  void analyzeLabels() async {
    if (widget._mode == AccBusinessCardScanDetail.MODE_SCAN_NEW) {
      try {
        List<VisionText> currentLabels;
        currentLabels = await textDetector.detectFromPath(widget._file.path);
        if (this.mounted) {
          setState(() {
            _multilineBc = visionTextToMultilineBC(currentLabels);
          });
        }
      } catch (e) {
        print("MyEx: " + e.toString());
      }
    } else {
      setState(() {
        _multilineBc = widget._bcString;
        _bcTitle = widget._key;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
        body: WidgetUtility.getStackWithProgressbar(getBody(), _showProgress));
  }

  Widget getBody() {
    saveTFieldContrlr.text = _bcTitle;
    return Column(
      children: <Widget>[
        buildBody(),
        TextField(
          controller: saveTFieldContrlr,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Please enter a name to save the business card'),
        ),
        RaisedButton(
            onPressed: () => onSaveTapped(),
            color: Colors.green,
            textColor: Colors.white,
            shape: WidgetUtility.getShape(5.0),
            child: new Text(LABEL_SAVE))
      ],
    );
  }

  void onSaveTapped() async {
    if (bcTFieldContrlr.text == null || bcTFieldContrlr.text.isEmpty) {
      WidgetUtility.showFlutterToast("Nothing to save!");
      return;
    }
    if (saveTFieldContrlr.text == null || saveTFieldContrlr.text.isEmpty) {
      WidgetUtility.showFlutterToast(
          "Enter valid name to save this Business card!!");
      return;
    }
    _multilineBc = bcTFieldContrlr.text; // copy updated text in the text field
    _bcTitle = saveTFieldContrlr.text; // copy updated text in the text field
    setState(() {
      _showProgress = true;
    });
    bool saveSuccessful = await AccBusinessCardDataHelper.saveBusinessCard(
        saveTFieldContrlr.text, bcTFieldContrlr.text.split("\n"));
    setState(() {
      _showProgress = false;
    });
    String statusMessage =
        saveSuccessful ? "Save successful" : "Save failed. Try later!!";
    WidgetUtility.showFlutterToast(statusMessage);
    Navigator.of(context).pop();
  }

  Widget buildBody() {
    if (_multilineBc.isEmpty) {
      return Expanded(
          flex: 1,
          child: Center(
            child: Text('No text detected',
                style: Theme.of(context).textTheme.subhead),
          ));
    }
    bcTFieldContrlr.text = _multilineBc;
    return Expanded(
        flex: 1,
        child: Container(
          child: TextField(
              maxLines: 10,
              controller: bcTFieldContrlr,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Business Card text goes here')),
        ));
  }

  String visionTextToMultilineBC(List<VisionText> texts) {
    StringBuffer multiline = StringBuffer();
    for (int i = 0; i < texts.length; i++) {
      multiline.write(texts[i].text);

      if (i != (texts.length - 1)) multiline.write("\n");
    }
    return multiline.toString();
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }
}
