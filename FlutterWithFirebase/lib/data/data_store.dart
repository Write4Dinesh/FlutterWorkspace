import 'package:sqflite/sqflite.dart';

class FFADBHelper {
  final int CURRENT_DB_VERSION = 1;

  String getLocationOfDatabase() async {
    var databasePath = await getDatabasesPath();
    databasePath
    .
    return
    databasePath
    +
    "
    acc.db
    ";
  }

  void openDB(String path,String TableName) async {
    Database database = await openDatabase(path, version: CURRENT_DB_VERSION,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        });
  }
}

