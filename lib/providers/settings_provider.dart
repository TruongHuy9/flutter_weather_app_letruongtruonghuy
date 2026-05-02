import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService storageService;

  String _windUnit = 'km/h';
  bool _is24Hour = true;
  String _language = 'vi';

  SettingsProvider(this.storageService);

  String get windUnit => _windUnit;
  bool get is24Hour => _is24Hour;
  String get language => _language;

  Future<void> loadSettings() async {
    _windUnit = await storageService.getWindSpeedUnit();
    _is24Hour = await storageService.getHourFormat();
    _language = await storageService.getLanguage();

    notifyListeners();
  }

  Future<void> changeWindUnit(String unit) async {
    _windUnit = unit;
    await storageService.setWindSpeedUnit(unit);
    notifyListeners();
  }

  Future<void> toggleHourFormat(bool value) async {
    _is24Hour = value;
    await storageService.setHourFormat(value);
    notifyListeners();
  }

  Future<void> changeLanguage(String lang) async {
    _language = lang;
    await storageService.setLanguage(lang);
    notifyListeners();
  }
}