import 'package:flutter/material.dart';
import 'package:flutfire/utils/widget_utility.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/data/acc_businesscard_data_helper.dart';

class AccViewBusinessCard extends StatefulWidget {
  final String _bCard;
  final String _key;

  AccViewBusinessCard(this._bCard, this._key);

  @override
  State createState() {
    return AccViewBusinessCardState(getList(), _key);
  }

  List<String> getList() {
    List<String> list = _bCard.split(AppConstants.CARD_FIELD_SEPARATOR);
    return list;
  }
}

class AccViewBusinessCardState extends State<AccViewBusinessCard> {
  List<String> bCardList;
  final String key;

  AccViewBusinessCardState(this.bCardList, this.key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: Column(
        children: <Widget>[buildDetailContainer(), buildButtonContainer()],
      ),
    );
  }

  Widget buildDetailContainer() {
    return Expanded(
        flex: 1,
        child: Container(
            child: ListView.builder(
                itemBuilder: (context, i) => getListItem(bCardList[i]),
                itemCount: bCardList.length)));
  }

  Widget getListItem(String text) {
    return ListTile(title: Text(text));
  }

  Widget buildButtonContainer() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          padding: EdgeInsets.only(left: 50.0, right: 50.0),
          color: Colors.green,
          textColor: Colors.white,
          shape: WidgetUtility.getShape(5.0),
          onPressed: () => WidgetUtility.showFlutterToast("Edit pressed"),
          child: Text("Edit"),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
        ),
        RaisedButton(
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            color: Colors.green,
            textColor: Colors.white,
            shape: WidgetUtility.getShape(5.0),
            onPressed: () =>
                AccBusinessCardDataHelper.removeBusinessCardByKey(key),
            child: Text("Delete"))
      ],
    );
  }
}
