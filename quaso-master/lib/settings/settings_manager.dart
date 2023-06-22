import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quaso/constants.dart';
import 'package:quaso/model/settings_data.dart';
import 'package:quaso/notifications.dart';
import 'package:quaso/themes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SettingsData _settingsData = SettingsData();
  bool _isInitialized = false;


  void initialize() async {
    await loadData();
    _isInitialized = true;
    notifyListeners();
  }

  resetAppNotification() {
    if (_settingsData.showDailyNot) {
      resetAppNotificationIfMissing(_settingsData.dailyNotTime);
    }
  }

  void saveData() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('quaso_settings', jsonEncode(_settingsData));
  }

  Future<void> loadData() async {
    final SharedPreferences prefs = await _prefs;
    String? json = prefs.getString('quaso_settings');
    if (json != null) {
      _settingsData = SettingsData.fromJson(jsonDecode(json));
    }
  }

  ThemeData get getDark {
    if (_settingsData.theme != Themes.light) {
      return QuasoTheme.darkTheme;
    } else {
      return QuasoTheme.lightTheme;
    }
  }

  ThemeData get getLight {
    if (_settingsData.theme != Themes.dark) {
      return QuasoTheme.lightTheme;
    } else {
      return QuasoTheme.darkTheme;
    }
  }

  String get getThemeString {
    return _settingsData.themeList[_settingsData.theme.index];
  }

  List<String> get getThemeList {
    return _settingsData.themeList;
  }

  String get getWeekStart {
    return _settingsData.weekStartList[_settingsData.weekStart.index];
  }

  StartingDayOfWeek get getWeekStartEnum {
    return _settingsData.weekStart;
  }

  List<String> get getWeekStartList {
    return _settingsData.weekStartList;
  }

  TimeOfDay get getDailyNot {
    return _settingsData.dailyNotTime;
  }

  bool get getShowDailyNot {
    return _settingsData.showDailyNot;
  }

  bool get getShowMonthName {
    return _settingsData.showMonthName;
  }

  bool get getSeenOnboarding {
    return _settingsData.seenOnboarding;
  }

  Color get checkColor {
    return _settingsData.checkColor;
  }

  Color get failColor {
    return _settingsData.failColor;
  }

  Color get skipColor {
    return _settingsData.skipColor;
  }

  bool get isInitialized {
    return _isInitialized;
  }

  set setTheme(String value) {
    _settingsData.theme = Themes.values[_settingsData.themeList.indexOf(value)];
    saveData();
    notifyListeners();
  }

  set setWeekStart(String value) {
    _settingsData.weekStart =
        StartingDayOfWeek.values[_settingsData.weekStartList.indexOf(value)];
    saveData();
    notifyListeners();
  }

  set setDailyNot(TimeOfDay notTime) {
    _settingsData.dailyNotTime = notTime;
    setAppNotification(notTime);
    saveData();
    notifyListeners();
  }

  set setShowDailyNot(bool value) {
    _settingsData.showDailyNot = value;
    if (value) {
      setAppNotification(_settingsData.dailyNotTime);
    } else {
      disableAppNotification();
    }
    saveData();
    notifyListeners();
  }

  set setShowMonthName(bool value) {
    _settingsData.showMonthName = value;
    saveData();
    notifyListeners();
  }

  set setSeenOnboarding(bool value) {
    _settingsData.seenOnboarding = value;
    saveData();
    notifyListeners();
  }

  set checkColor(Color value) {
    _settingsData.checkColor = value;
    saveData();
    notifyListeners();
  }

  set failColor(Color value) {
    _settingsData.failColor = value;
    saveData();
    notifyListeners();
  }

  set skipColor(Color value) {
    _settingsData.skipColor = value;
    saveData();
    notifyListeners();
  }
}
