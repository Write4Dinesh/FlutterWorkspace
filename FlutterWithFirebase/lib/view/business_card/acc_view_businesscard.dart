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
    return AccViewBusinessCardState(getList());
  }

  List<String> getList() {
    List<String> list = _bCard.split(AppConstants.CARD_FIELD_SEPARATOR);
    return list;
  }
}

class AccViewBusinessCardState extends State<AccViewBusinessCard> {
  List<String> bCardList;
  bool _showProgressBar = false;

  AccViewBusinessCardState(this.bCardList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._key)),
      body: WidgetUtility.getStackWithProgressbar(
          Container(color: Colors.black12, child: getCard(context)),
          _showProgressBar),
    );
  }

  Widget getListItem(String text) {
    return ListTile(title: Text(text));
  }

  void goToNextScreen(BuildContext context) {
    StringBuffer buffer = StringBuffer();
    for (String s in bCardList) {
      buffer.writeln(s);
    }
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => EditBusinessCard(
            null,
            EditBusinessCard.MODE_EDIT,
            buffer.toString(),
            widget._key));
    Navigator.of(context).push(route);
  }

  Widget getCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.deepPurple);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    List<Widget> buttonBar = <Widget>[];
    buttonBar.add(FlatButton(
      child: const Text('Edit'),
      onPressed: () {
        goToNextScreen(context);
      },
    ));
    buttonBar.add(FlatButton(
      child: const Text('Delete'),
      onPressed: () {
        remove();
      },
    ));

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text(
              widget._key,
              style: titleStyle,
            ),
            subtitle: Text(widget._bCard, style: descriptionStyle),
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
