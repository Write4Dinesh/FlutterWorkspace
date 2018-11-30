import 'package:flutfire/mlkit/acc_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutfire/view/acc_choose_image_source.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/business_logic/models/scanner_model.dart';
import 'package:flutfire/utils/widget_utility.dart';
import 'package:flutfire/view/business_card/acc_show_businesscard_list.dart';
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

  String _selectedScanner = AppConstants.TEXT_SCANNER;

  @override
  Widget build(BuildContext context) {
    final columns = List<Widget>();

    //choose the ML feature
    //columns.add(buildTitle(context, 'Select Scanner Type'));
    columns.add(buildMLKitScannerList(context));

    var homeScaffold = Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppConstants.APP_NAME),
        ),
        body: Container(
            color: WidgetUtility.getGlobalScreenBgColor(),
            child: SingleChildScrollView(
                child: WidgetUtility.buildPadding(
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: columns,
                    ),
                    AppConstants.GLOBAL_SCREEN_LEFT_PADDING,
                    AppConstants.GLOBAL_SCREEN_RIGHT_PADDING,
                    10,
                    10))));

    var willPopScope = WillPopScope(onWillPop: _onWillPop, child: homeScaffold);

    return willPopScope;
  }

  Widget buildTitle(BuildContext context, String title) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 26.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
      ),
    ));
  }

  Widget getRaisedButtonForBC(BuildContext context, ScannerModel model) {
    return SizedBox(
        width: 200.0,
        child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () {
              final MaterialPageRoute chooseImageSourcePage = MaterialPageRoute(
                  builder: (context) => AccShowBusinessCardList());
              Navigator.of(context).push(chooseImageSourcePage);
            },
            shape: WidgetUtility.getShape(5.0),
            child: Text("Show Business Card List")));
  }

  void goToNextScreen(ScannerModel model) {
    final MaterialPageRoute chooseImageSourcePage =
        MaterialPageRoute(builder: (context) => ACCChooseImageSource(model));
    Navigator.of(context).push(chooseImageSourcePage);
  }

  Widget buildMLKitScannerList(BuildContext context) {
    ScannerModel businessCardScannerModel = ScannerModel()
      ..scannerType = AppConstants.TEXT_SCANNER
      ..tileTitle = "MLKit Text Recognition"
      ..tileDescription = "Scan business card, edit & save."
      ..screenTitle = AppConstants.BUSINESS_CARD_SCANNER_SCREEN_TITLE;

   /* ScannerModel businessCardListModel = ScannerModel()
      ..scannerType = AppConstants.TEXT_SCANNER_LIST
      ..tileTitle = "same as above"
      ..tileDescription = "same as above"
      ..screenTitle = AppConstants.BUSINESS_CARD_LIST_SCREEN_TITLE;*/

    ScannerModel barcodeScannerModel = ScannerModel()
      ..scannerType = AppConstants.BARCODE_SCANNER
      ..tileTitle = "MLkit Barcode Scanning"
      ..tileDescription = "Scan barcode & search the web"
      ..screenTitle = AppConstants.BARCODE_SCANNER_SCREEN_TITLE;

    ScannerModel labelScannerModel = ScannerModel()
      ..scannerType = AppConstants.LABEL_SCANNER
      ..tileTitle = "MLKit Labelling a Face parts"
      ..tileDescription = "Scan the face & list the various parts of the face"
      ..screenTitle = AppConstants.LABEL_SCANNER_SCREEN_TITLE;

    ScannerModel faceDetectionScannerModel = ScannerModel()
      ..scannerType = AppConstants.FACE_SCANNER
      ..tileTitle = "MLKit Face detection"
      ..tileDescription = "Scan the face & draw shape aroun the face"
      ..screenTitle = AppConstants.FACE_DETECTION_SCANNER_SCREEN_TITLE;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getCard(context, businessCardScannerModel),
        getCard(context, barcodeScannerModel),
        getCard(context, labelScannerModel),
        getCard(context, faceDetectionScannerModel),
        //getCard(context, businessCardListModel)
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
          builder: (context) =>  AlertDialog(
                title:  Text('Exit app',style:WidgetUtility.getTitleStyle(context)),
                content:  Text('Do you want to exit the App?',style: WidgetUtility.getSubTitleStyle(context),),
                actions: <Widget>[
                   FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child:  Text('No',style: WidgetUtility.getButtonLabelStyle(context)),
                  ),
                   FlatButton(
                    onPressed: () => exit(0),
                    child:  Text('Yes',style: WidgetUtility.getButtonLabelStyle(context)),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Widget getCard(BuildContext context, ScannerModel model) {
    List<Widget> buttonBar = <Widget>[];
    buttonBar.add(FlatButton(
      child:
          Text('SCAN NEW', style: WidgetUtility.getButtonLabelStyle(context)),
      onPressed: () {
        goToNextScreen(model);
      },
    ));
    if (model.type == AppConstants.TEXT_SCANNER) {
      buttonBar.add(FlatButton(
        child: Text('VIEW SAVED',
            style: WidgetUtility.getButtonLabelStyle(context)),
        onPressed: () {
          final MaterialPageRoute chooseImageSourcePage = MaterialPageRoute(
              builder: (context) => AccShowBusinessCardList());
          Navigator.of(context).push(chooseImageSourcePage);
        },
      ));
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              model.tileTitle,
              style: WidgetUtility.getTitleStyle(context),
            ),
            subtitle: Text(model.tileDescription,
                style: WidgetUtility.getSubTitleStyle(context)),
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: buttonBar,
            ),
          ),
        ],
      ),
    );
  }
}
