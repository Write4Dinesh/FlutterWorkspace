import 'package:flutfire/mlkit/acc_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutfire/choosers/acc_choose_image_source.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppContstants;
import 'package:flutfire/models/scanner_model.dart';
import 'package:flutfire/utils/widget_utility.dart';

class AccHome extends StatefulWidget {
  AccHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccHomeState();
}

class _AccHomeState extends State<AccHome> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedScanner = AppContstants.TEXT_SCANNER;

  @override
  Widget build(BuildContext context) {
    final columns = List<Widget>();

    //choose the ML feature
    columns.add(buildRowTitle(context, 'Select Scanner Type'));
    columns.add(buildSelectScannerRowWidget(context));

    var homeScaffold = Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppContstants.APP_NAME),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: columns,
          ),
        ));

    var willPopScope = WillPopScope(onWillPop: _onWillPop, child: homeScaffold);

    return willPopScope;
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

  Widget getRaisedButton(BuildContext context, ScannerModel model) {
    return SizedBox(
        width: 200.0,
        child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () => goToNextScreen(model),
            shape: WidgetUtility.getShape(5.0),
            child: Text(model.title)));
  }

  void goToNextScreen(ScannerModel model) {
    final MaterialPageRoute chooseImageSourcePage =
        MaterialPageRoute(builder: (context) => ACCChooseImageSource(model));
    Navigator.of(context).push(chooseImageSourcePage);
  }

  Widget buildSelectScannerRowWidget(BuildContext context) {
    ScannerModel businessCardScannerModel = ScannerModel()
      ..scannerType = AppContstants.TEXT_SCANNER
      ..title = AppContstants.BUSINESS_CARD_SCANNER_SCREEN_TITLE;
    ScannerModel barcodeScannerModel = ScannerModel()
      ..scannerType = AppContstants.BARCODE_SCANNER
      ..title = AppContstants.BARCODE_SCANNER_SCREEN_TITLE;
    ScannerModel labelScannerModel = ScannerModel()
      ..scannerType = AppContstants.LABEL_SCANNER
      ..title = AppContstants.LABEL_SCANNER_SCREEN_TITLE;
    ScannerModel faceDetectionScannerModel = ScannerModel()
      ..scannerType = AppContstants.FACE_SCANNER
      ..title = AppContstants.FACE_DETECTION_SCANNER_SCREEN_TITLE;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getRaisedButton(context, businessCardScannerModel),
        getRaisedButton(context, barcodeScannerModel),
        getRaisedButton(context, labelScannerModel),
        getRaisedButton(context, faceDetectionScannerModel),
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

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit the App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => exit(0),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
