import 'package:shared_preferences/shared_preferences.dart';

class AccDataStore {
  SharedPreferences prefs;
  static AccDataStore instance = AccDataStore();

  _AccDataStore() {}

  loadStringByKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }

  Future<bool> saveStringByKey(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> success = prefs.setString(key, value);
    return success;
  }

  Future<bool> removeStringByKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> result = prefs.remove(key);
    return result;
  }
}
