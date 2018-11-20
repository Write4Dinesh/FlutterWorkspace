import 'package:flutfire/choosers/acc_choose_image_source.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:mlkit/mlkit.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;

class AccBusinessCardScanDetail extends StatefulWidget {
  final File _file;

  AccBusinessCardScanDetail(this._file);

  @override
  State<StatefulWidget> createState() {
    return _AccScanDetailState();
  }
}

class _AccScanDetailState extends State<AccBusinessCardScanDetail> {
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;

  List<VisionText> _currentTextLabels = <VisionText>[];

  Stream sub;
  StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    sub = new Stream.empty();
    subscription = sub.listen((_) => _getImageSize)..onDone(analyzeLabels);
  }

  void analyzeLabels() async {
    try {
      var currentLabels;
      currentLabels = await textDetector.detectFromPath(widget._file.path);
      if (this.mounted) {
        setState(() {
          _currentTextLabels = currentLabels;
        });
      }
    } catch (e) {
      print("MyEx: " + e.toString());
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
        body: buildTextList(_currentTextLabels));
  }

  Widget _buildTextRow(text) {
    return ListTile(
      title: Text(
        "$text",
      ),
      dense: true,
    );
  }

  Widget buildTextList(List<VisionText> texts) {
    if (texts.length == 0) {
      return Expanded(
          flex: 1,
          child: Center(
            child: Text('No text detected',
                style: Theme.of(context).textTheme.subhead),
          ));
    }
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(1.0),
          itemCount: texts.length,
          itemBuilder: (context, i) {
            return _buildTextRow(texts[i].text);
          }),
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }
}
