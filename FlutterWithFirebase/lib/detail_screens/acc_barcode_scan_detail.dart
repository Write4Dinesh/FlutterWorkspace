import 'package:flutfire/choosers/acc_choose_image_source.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:mlkit/mlkit.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;

class AccBarcodeScanDetail extends StatefulWidget {
  final File _file;

  AccBarcodeScanDetail(this._file);

  @override
  State<StatefulWidget> createState() {
    return _AccScanDetailState();
  }
}

class _AccScanDetailState extends State<AccBarcodeScanDetail> {
  FirebaseVisionBarcodeDetector barcodeDetector =
      FirebaseVisionBarcodeDetector.instance;
  List<VisionBarcode> _currentBarcodeLabels = <VisionBarcode>[];

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
      currentLabels = await barcodeDetector.detectFromPath(widget._file.path);
      if (this.mounted) {
        setState(() {
          _currentBarcodeLabels = currentLabels;
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
          title: Text(AppConstants.BARCODE_SCANNER_SCREEN_TITLE),
        ),
        body: Column(
          children: <Widget>[
            buildBarcodeList<VisionBarcode>(_currentBarcodeLabels),
          ],
        ));
  }

  Widget buildBarcodeList<T>(List<T> barcodes) {
    if (barcodes.length == 0) {
      return Expanded(
        flex: 1,
        child: Center(
          child: Text('Nothing detected',
              style: Theme.of(context).textTheme.subhead),
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: barcodes.length,
            itemBuilder: (context, i) {
              var text;
              final barcode = barcodes[i];
              VisionBarcode res = barcode as VisionBarcode;
              text = "Raw Value: ${res.rawValue}";
              return _buildTextRow(text);
            }),
      ),
    );
  }

  Widget _buildTextRow(text) {
    return ListTile(
      title: Text(
        "$text",
      ),
      dense: true,
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
