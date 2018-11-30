import 'package:flutter/material.dart';
import 'package:flutfire/utils/widget_utility.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/data/business_card/acc_businesscard_data_helper.dart';
import 'package:flutfire/view/business_card/edit_business_card.dart';

class AccViewBusinessCard extends StatefulWidget {
  final String _bCard;
  final String _key;

  AccViewBusinessCard(this._bCard, this._key);

  @override
  State createState() {
    return AccViewBusinessCardState();
  }
}

class AccViewBusinessCardState extends State<AccViewBusinessCard> {
  bool _showProgressBar = false;

  AccViewBusinessCardState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._key)),
      body: WidgetUtility.getStackWithProgressbar(
          Container(
              color: WidgetUtility.getGlobalScreenBgColor(),
              child: WidgetUtility.buildPadding(
                  getCard(context),
                  AppConstants.GLOBAL_SCREEN_LEFT_PADDING,
                  AppConstants.GLOBAL_SCREEN_RIGHT_PADDING,
                  5,
                  5)),
          _showProgressBar),
    );
  }

  Widget getListItem(String text) {
    return ListTile(title: Text(text));
  }

  void goToNextScreen(BuildContext context) {
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => EditBusinessCard(
            null, EditBusinessCard.MODE_EDIT, widget._bCard, widget._key));
    Navigator.of(context).push(route);
  }

  Widget getCard(BuildContext context) {
    List<Widget> buttonBar = <Widget>[];
    buttonBar.add(FlatButton(
      child:  Text('EDIT',style: WidgetUtility.getButtonLabelStyle(context)),
      onPressed: () {
        goToNextScreen(context);
      },
    ));
    buttonBar.add(FlatButton(
      child:  Text('DELETE',style: WidgetUtility.getButtonLabelStyle(context)),
      onPressed: () {
        remove();
      },
    ));

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            /*leading: Icon(Icons.add_circle),*/
            title: Text(
              widget._key,
              style: WidgetUtility.getTitleStyle(context),
            ),
            subtitle: Text(widget._bCard, style: WidgetUtility.getSubTitleStyle(context)),
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

  void remove() async {
    bool removed = false;
    setState(() {
      _showProgressBar = true;
    });
    removed =
        await AccBusinessCardDataHelper.removeBusinessCardByKey(widget._key);
    setState(() {
      _showProgressBar = false;
    });
    WidgetUtility.showFlutterToast(
        removed ? "Deleted Successfully!!" : "Failed to Delete");
    if (removed) {
      Navigator.of(context).pop();
    }
  }
}
