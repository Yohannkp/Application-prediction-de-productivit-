import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PredictionHistoryService {
  static const String _historyKey = 'prediction_history';

  Future<List<Map<String, dynamic>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? rawList = prefs.getStringList(_historyKey);
    if (rawList == null) return [];
    return rawList.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
  }

  Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = history.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_historyKey, rawList);
  }

  Future<void> addEntry(Map<String, dynamic> entry) async {
    final history = await loadHistory();
    history.add(entry);
    await saveHistory(history);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
