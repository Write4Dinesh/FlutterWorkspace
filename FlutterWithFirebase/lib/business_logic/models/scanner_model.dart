class ScannerModel {
  String _type;
  String _screenTitle;
  String _tileTitle;
  String _tileDescription;

  String get type => _type;

  set scannerType(type) {
    this._type = type;
  }

  String get screenTitle => _screenTitle;

  set screenTitle(title) {
    this._screenTitle = title;
  }

  String get tileTitle => _tileTitle;

  set tileTitle(tileTitle) {
    this._tileTitle = tileTitle;
  }

  String get tileDescription => _tileDescription;

  set tileDescription(tileDescription) {
    this._tileDescription = tileDescription;
  }
}
