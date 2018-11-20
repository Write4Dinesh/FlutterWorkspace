import 'package:flutfire/mlkit/acc_businesscard_scan_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutfire/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/business_card_scanner_model.dart';
import 'package:flutfire/scanner_model.dart';

const String PICK_IMAGE_LABEL_CAMERA = 'Camera';
const String PICK_IMAGE_LABEL_GALLERY = 'Gallery';

/* ************************WIDGET class **************************/
class ACCBusinessCardScanner extends StatefulWidget {
  final String title;
  final ScannerModel scannerModel;

  ACCBusinessCardScanner(this.scannerModel,
      {Key key, this.title: 'Pick an image from'})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ACCBusinessCardScannerState(scannerModel);
}
/* ************************STATE class **************************/

class _ACCBusinessCardScannerState extends State<ACCBusinessCardScanner> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';
  ScannerModel scannerModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _ACCBusinessCardScannerState(this.scannerModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppConstants.BUSINESS_CARD_SCAN_TITLE),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildTitleWidget(context, scannerModel.title),
              buildButtonWidgets(
                  context, PICK_IMAGE_LABEL_CAMERA, CAMERA_SOURCE),
              buildButtonWidgets(
                  context, PICK_IMAGE_LABEL_GALLERY, GALLERY_SOURCE)
            ],
          ),
        ));
  }

  Widget buildTitleWidget(BuildContext context, String title) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 26.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
      ),
    ));
  }

  /* ++++++++++++++++++++++ build Raised Buttons to pick image form either Gallery or Camera +++++++++++++++++++ */
  Widget buildButtonWidgets(
      BuildContext context, String label, String scanType) {
    return RaisedButton(
        color: Colors.green,
        textColor: Colors.white,
        splashColor: Colors.blueGrey,
        onPressed: () {
          onPickImageSelected(scanType);
        },
        child: Text(label));
  }

  /* ++++++++++++++ pick an image from either gallery or camera ++++++++++++++ */
  void onPickImageSelected(String source) async {
    var imageSource =
        (source == CAMERA_SOURCE) ? ImageSource.camera : ImageSource.gallery;
    final scaffold = _scaffoldKey.currentState;

    try {
      final pickedImageFile = await ImagePicker.pickImage(source: imageSource);
      if (pickedImageFile == null) {
        throw Exception('File is not available');
      }
      // Image file is fetched successfully. pass this to next screen for processing
      goToNextScreen(context, pickedImageFile);
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  void goToNextScreen(BuildContext context, File pickedImageFile) {
    var type;
    switch (this.scannerModel.type) {
      case AppConstants.TEXT_SCANNER:
        type = AccBusinessCardScanDetail(
            pickedImageFile, AppConstants.TEXT_SCANNER);

        break;
    }
    Navigator.push(context, new MaterialPageRoute(builder: (context) => type));
  }
}
