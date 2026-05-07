import 'package:shared_preferences/shared_preferences.dart';

class HistoriqueService {
  static const String _key = 'historique_actions';
  static const String _unreadKey = 'unread_notifications_count';

  static Future<List<String>> getHistorique() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    
    final String timestamp = DateTime.now().toString().substring(0, 16);
    history.insert(0, "$timestamp - $action");
    
    await prefs.setStringList(_key, history);

    // Increment unread count
    final int unreadCount = prefs.getInt(_unreadKey) ?? 0;
    await prefs.setInt(_unreadKey, unreadCount + 1);
  }

  static Future<int> getUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_unreadKey) ?? 0;
  }

  static Future<void> resetUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unreadKey, 0);
  }

  static Future<void> clearHistorique() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
