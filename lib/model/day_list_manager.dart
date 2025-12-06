import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'day_model.dart';

class DayListManager extends ChangeNotifier {
  static const String _dayNamesKey = 'custom_day_names';
  List<String> _dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  List<DayModel> _dayModels = [];

  List<String> get dayNames => _dayNames;
  List<DayModel> get dayModels => _dayModels;

  DayListManager._internal();

  static Future<DayListManager> create() async {
    final manager = DayListManager._internal();
    await manager._loadDayNames();
    await manager._loadDayModels();
    return manager;
  }

  Future<void> _loadDayNames() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNames = prefs.getStringList(_dayNamesKey);
    if (savedNames != null && savedNames.isNotEmpty) {
      _dayNames = savedNames;
    }
  }

  Future<void> _loadDayModels() async {
    _dayModels = await Future.wait(
      _dayNames.map((day) => DayModel.create(dayName: day)).toList(),
    );
    notifyListeners();
  }

  Future<void> _saveDayNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_dayNamesKey, _dayNames);
  }

  Future<void> removeDay(DayModel model) async {
    _dayModels.removeWhere((m) => m.dayName == model.dayName);
    _dayNames.removeWhere((name) => name == model.dayName);

    await _saveDayNames();
    await model.deleteData();
    notifyListeners();
  }

  Future<void> addDay(String name) async {
    if (_dayNames.contains(name)) return;

    _dayNames.add(name);
    await _saveDayNames();

    final newDayModel = await DayModel.create(dayName: name);
    _dayModels.add(newDayModel);

    notifyListeners();
  }
}
