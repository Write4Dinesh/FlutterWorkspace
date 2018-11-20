import 'package:flutfire/mlkit/acc_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'acc_businesscard_scan.dart';
import 'acc_barcode_scan.dart';
import 'acc_face_detection.dart';
import 'acc_lable_scan.dart';
import 'package:flutfire/acc_app_constants.dart' as AppContstants;
import 'package:flutfire/business_card_scanner_model.dart';

const String TEXT_SCANNER = 'TEXT_SCANNER';
const String BARCODE_SCANNER = 'BARCODE_SCANNER';
const String LABEL_SCANNER = 'LABEL_SCANNER';
const String FACE_SCANNER = 'FACE_SCANNER';

class AccHome extends StatefulWidget {
  AccHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccHomeState();
}

class _AccHomeState extends State<AccHome> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _file;
  String _selectedScanner = TEXT_SCANNER;

  @override
  Widget build(BuildContext context) {
    final columns = List<Widget>();

    //choose the ML feature
    columns.add(buildRowTitle(context, 'Select Scanner Type'));
    columns.add(buildSelectScannerRowWidget(context));

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppContstants.HOME_PAGE_TITLE),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: columns,
          ),
        ));
  }

  Widget buildRowTitle(BuildContext context, String title) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 26.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
      ),
    ));
  }

  Widget getRaisedButton(
      BuildContext context, String label, MaterialPageRoute goToPage) {
    return SizedBox(
        width: 200.0,
        child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () {
              Navigator.of(context).push(goToPage);
              //onPickImageSelected(CAMERA_SOURCE);
            },
            child: Text(label)));
  }

  Widget buildSelectScannerRowWidget(BuildContext context) {
    BusinessCardScannerModel businessCardScanner = BusinessCardScannerModel()
      ..scannerType = AppContstants.TEXT_SCANNER
      ..title = "Business Card Scanner";

    final MaterialPageRoute businessCarePage = MaterialPageRoute(
        builder: (context) => ACCBusinessCardScanner(businessCardScanner));
    final MaterialPageRoute faceScannerPage =
        MaterialPageRoute(builder: (context) => AccFaceScanner());
    final MaterialPageRoute labelScannerPage =
        MaterialPageRoute(builder: (context) => AccLableScanner());
    final MaterialPageRoute barcodeScannerPage =
        MaterialPageRoute(builder: (context) => AccBarcodeScanner());
    List labels = <String>[
      "BusinessCard Scanner",
      "Face Scanner",
      "Label Scanner",
      "Barcode Scanner"
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getRaisedButton(context, labels[0], businessCarePage),
        getRaisedButton(context, labels[1], faceScannerPage),
        getRaisedButton(context, labels[2], labelScannerPage),
        getRaisedButton(context, labels[3], barcodeScannerPage),
      ],
    );
  }

  Widget buildImageRow(BuildContext context, File file) {
    return SizedBox(
        height: 500.0,
        child: Image.file(
          file,
          fit: BoxFit.fitWidth,
        ));
  }

  Widget buildDeleteRow(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () {
              setState(() {
                _file = null;
              });
              ;
            },
            child: const Text('Delete Image')),
      ),
    );
  }

  void onScannerSelected(String scanner) {
    setState(() {
      _selectedScanner = scanner;
    });
  }

  void onPickImageSelected(String source) async {
    var imageSource;
    if (source == CAMERA_SOURCE) {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    final scaffold = _scaffoldKey.currentState;

    try {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('File is not available');
      }

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => AccScanDetail(file, _selectedScanner)),
      );
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
