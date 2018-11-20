import 'package:flutfire/detail_screens/acc_businesscard_scan_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/models/scanner_model.dart';
import 'package:flutfire/detail_screens/acc_barcode_scan_detail.dart';
import 'package:flutfire/detail_screens/acc_face_scan_detail.dart';
import 'package:flutfire/detail_screens/acc_label_scan_detail.dart';

const String PICK_IMAGE_LABEL_CAMERA = 'Camera';
const String PICK_IMAGE_LABEL_GALLERY = 'Gallery';

/* ************************WIDGET class **************************/
class ACCChooseImageSource extends StatefulWidget {
  final String title;
  final ScannerModel scannerModel;

  ACCChooseImageSource(this.scannerModel,
      {Key key, this.title: 'Pick an image from'})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ACCChooseImageSourceState(scannerModel);
}
/* ************************STATE class **************************/

class _ACCChooseImageSourceState extends State<ACCChooseImageSource> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';
  ScannerModel scannerModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _ACCChooseImageSourceState(this.scannerModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.scannerModel.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildTitleWidget(context, widget.title),
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
    var detailObj;
    switch (this.scannerModel.type) {
      case AppConstants.TEXT_SCANNER:
        detailObj = AccBusinessCardScanDetail(pickedImageFile);

        break;
      case AppConstants.BARCODE_SCANNER:
        detailObj = AccBarcodeScanDetail(pickedImageFile);

        break;
      case AppConstants.FACE_SCANNER:
        detailObj = AccFaceScanDetail(pickedImageFile, this.scannerModel.type);

        break;
      case AppConstants.LABEL_SCANNER:
        detailObj = AccLabelScanDetail(pickedImageFile, this.scannerModel.type);

        break;
    }
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => detailObj));
  }
}
