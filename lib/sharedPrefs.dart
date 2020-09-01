import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferanceHelper {
  static Future<int> getCoins() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('coins') ?? '0';
  }

  static Future increaseCoins(int coins, int inc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('coins', coins + inc);
  }

  static Future decreaseCoins(int coins, int inc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('coins', coins - inc);
  }
}
