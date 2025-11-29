import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DayModel extends ChangeNotifier {
  final String dayName;
  final String _keyPrefix;

  static const int _defaultMove = 30;
  static const int _defaultRest = 30;
  static const List<String> _defaultHiit = ["Seated Knee Tuck", "Mountain Climber", "Push Up"];
  static const List<String> _defaultWo = ["Deadlift", "Bench Press", "Squat"];

  String _hiitTitle = "HIIT";
  String _woTitle = "Workout";
  int _moveDurationSeconds = _defaultMove;
  int _restDurationSeconds = _defaultRest;
  List<String> _hiitMovements = _defaultHiit.toList();
  List<String> _woMovements = _defaultWo.toList();

  DayModel._internal({required this.dayName}) : _keyPrefix = dayName.toLowerCase();

  static Future<DayModel> create({required String dayName}) async {
    final model = DayModel._internal(dayName: dayName);
     await model._loadData();
    return model;
  }

  String get hiitTitle => _hiitTitle;
  String get woTitle => _woTitle;
  int get moveDurationSeconds => _moveDurationSeconds;
  int get restDurationSeconds => _restDurationSeconds;
  List<String> get hiitMovements => _hiitMovements;
  List<String> get woMovements => _woMovements;


  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    _hiitTitle = prefs.getString('${_keyPrefix}_hiit_title') ?? _hiitTitle;
    _woTitle = prefs.getString('${_keyPrefix}_wo_title') ?? _woTitle;

    _moveDurationSeconds = prefs.getInt('${_keyPrefix}_move_dur') ?? _moveDurationSeconds;
    _restDurationSeconds = prefs.getInt('${_keyPrefix}_rest_dur') ?? _restDurationSeconds;

    try {
      final hiitJson = prefs.getString('${_keyPrefix}_hiit_movements');
      if (hiitJson != null) {
        _hiitMovements = List<String>.from(jsonDecode(hiitJson));
      }
      final woJson = prefs.getString('${_keyPrefix}_wo_movements');
      if (woJson != null) {
        _woMovements = List<String>.from(jsonDecode(woJson));
      }
    } catch (e) {
      print("Error loading list data: $e");
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('${_keyPrefix}_hiit_title', _hiitTitle);
    await prefs.setString('${_keyPrefix}_wo_title', _woTitle);

    await prefs.setInt('${_keyPrefix}_move_dur', _moveDurationSeconds);
    await prefs.setInt('${_keyPrefix}_rest_dur', _restDurationSeconds);

    await prefs.setString('${_keyPrefix}_hiit_movements', jsonEncode(_hiitMovements));
    await prefs.setString('${_keyPrefix}_wo_movements', jsonEncode(_woMovements));
  }


  void setHiitTitle(String title) {
    _hiitTitle = title;
    _saveData();
    notifyListeners();
  }

  void setWoTitle(String title) {
    _woTitle = title;
    _saveData();
    notifyListeners();
  }

  void setMoveDuration(int duration) {
    _moveDurationSeconds = duration < 5 ? 5 : duration;
    _saveData();
    notifyListeners();
  }

  void setRestDuration(int duration) {
    _restDurationSeconds = duration < 5 ? 5 : duration;
    _saveData();
    notifyListeners();
  }

  void updateMovement(List<String> list, int index, String newValue) {
    if (list == _hiitMovements) {
      _hiitMovements[index] = newValue;
    } else if (list == _woMovements) {
      _woMovements[index] = newValue;
    }
    _saveData();
    notifyListeners();
  }

  void addMovement(String type) {
    if (type == 'hiit') {
      _hiitMovements.add("");
    } else {
      _woMovements.add("");
    }
    _saveData();
    notifyListeners();
  }

  void removeMovement(List<String> list, int index) {
    list.removeAt(index);
    _saveData();
    notifyListeners();
  }
}
