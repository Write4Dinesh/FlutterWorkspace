import 'package:flutter/material.dart';
import 'package:flutfire/utils/widget_utility.dart';
import 'package:flutfire/utils/acc_app_constants.dart' as AppConstants;
import 'package:flutfire/data/acc_businesscard_data_helper.dart';
import 'package:flutfire/detail_screens/acc_businesscard_scan_detail.dart';

class AccViewBusinessCard extends StatefulWidget {
  final String _bCard;
  final String _key;

  AccViewBusinessCard(this._bCard, this._key);

  @override
  State createState() {
    return AccViewBusinessCardState(getList());
  }

  List<String> getList() {
    List<String> list = _bCard.split(AppConstants.CARD_FIELD_SEPARATOR);
    return list;
  }
}

class AccViewBusinessCardState extends State<AccViewBusinessCard> {
  List<String> bCardList;

  AccViewBusinessCardState(this.bCardList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._key)),
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
          onPressed: () => goToNextScreen(context),
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
                AccBusinessCardDataHelper.removeBusinessCardByKey(widget._key),
            child: Text("Delete"))
      ],
    );
  }

  void goToNextScreen(BuildContext context) {
    StringBuffer buffer = StringBuffer();
    for (String s in bCardList) {
      buffer.writeln(s);
    }
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => AccBusinessCardScanDetail(
            null,
            AccBusinessCardScanDetail.MODE_EDIT,
            buffer.toString(),
            widget._key));
    Navigator.of(context).push(route);
  }
}
