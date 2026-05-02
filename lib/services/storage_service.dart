import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import 'dart:convert';

class StorageService {
  SharedPreferences? _prefs;

  // INIT
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // SAVE
  Future<void> saveWeatherData(WeatherModel weather) async {
    if (_prefs == null) await init();

    final weatherWithTimestamp = WeatherModel(
      cityName: weather.cityName,
      country: weather.country,
      temperature: weather.temperature,
      feelsLike: weather.feelsLike,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
      pressure: weather.pressure,
      description: weather.description,
      icon: weather.icon,
      mainCondition: weather.mainCondition,
      dateTime: weather.dateTime,
      tempMin: weather.tempMin,
      tempMax: weather.tempMax,
      visibility: weather.visibility,
      cloudiness: weather.cloudiness,
      sunrise: weather.sunrise,
      sunset: weather.sunset,
      uvi: weather.uvi,
      cachedAt: DateTime.now(),
    );

    await _prefs!.setString(
      'weather',
      jsonEncode(weatherWithTimestamp.toJson()),
    );
  }

  // LOAD
  Future<WeatherModel?> getCachedWeather() async {
    if (_prefs == null) await init();

    final data = _prefs!.getString('weather');
    if (data == null) return null;

    final json = jsonDecode(data);
    final cachedAtStr = json['cachedAt'] as String?;
    final cachedAt = cachedAtStr != null ? DateTime.parse(cachedAtStr) : null;
    
    return WeatherModel.fromJson(json, cachedAt: cachedAt);
  }

  Future<void> clearCache() async {
    if (_prefs == null) await init();
    await _prefs!.remove('weather');
  }


  Future<void> addRecentSearch(String cityName) async {
    if (_prefs == null) await init();

    List<String> recentSearches = _prefs!.getStringList('recentSearches') ?? [];
    
    recentSearches.remove(cityName);
    recentSearches.insert(0, cityName);

    if (recentSearches.length > 10) {
      recentSearches = recentSearches.sublist(0, 10);
    }

    await _prefs!.setStringList('recentSearches', recentSearches);
  }

  Future<List<String>> getRecentSearches() async {
    if (_prefs == null) await init();
    return _prefs!.getStringList('recentSearches') ?? [];
  }

  Future<void> clearRecentSearches() async {
    if (_prefs == null) await init();
    await _prefs!.remove('recentSearches');
  }

  // FAVORITE CITIES (thành phố yêu thích, tối đa 5)
  Future<bool> addFavoriteCity(String cityName) async {
    if (_prefs == null) await init();

    List<String> favorites = _prefs!.getStringList('favoritesCities') ?? [];

    if (favorites.contains(cityName)) return false; 

    if (favorites.length >= 5) return false;

    favorites.add(cityName);
    await _prefs!.setStringList('favoritesCities', favorites);
    return true;
  }

  Future<void> removeFavoriteCity(String cityName) async {
    if (_prefs == null) await init();

    List<String> favorites = _prefs!.getStringList('favoritesCities') ?? [];
    favorites.remove(cityName);
    await _prefs!.setStringList('favoritesCities', favorites);
  }

  Future<List<String>> getFavoriteCities() async {
    if (_prefs == null) await init();
    return _prefs!.getStringList('favoritesCities') ?? [];
  }

  Future<bool> isFavorite(String cityName) async {
    final favorites = await getFavoriteCities();
    return favorites.contains(cityName);
  }

  Future<void> clearFavorites() async {
    if (_prefs == null) await init();
    await _prefs!.remove('favoritesCities');
  }


  // WIND SPEED UNIT (km/h, m/s, mph)
  Future<void> setWindSpeedUnit(String unit) async {
    if (_prefs == null) await init();
    await _prefs!.setString('windSpeedUnit', unit);
  }

  Future<String> getWindSpeedUnit() async {
    if (_prefs == null) await init();
    return _prefs!.getString('windSpeedUnit') ?? 'km/h';
  }

  // HOUR FORMAT (12/24)
  Future<void> setHourFormat(bool is24Hour) async {
    if (_prefs == null) await init();
    await _prefs!.setBool('is24HourFormat', is24Hour);
  }

  Future<bool> getHourFormat() async {
    if (_prefs == null) await init();
    return _prefs!.getBool('is24HourFormat') ?? true; // Default 24h
  }

  // LANGUAGE
  Future<void> setLanguage(String language) async {
    if (_prefs == null) await init();
    await _prefs!.setString('language', language);
  }

  Future<String> getLanguage() async {
    if (_prefs == null) await init();
    return _prefs!.getString('language') ?? 'vi'; // Default Vietnamese
  }
}