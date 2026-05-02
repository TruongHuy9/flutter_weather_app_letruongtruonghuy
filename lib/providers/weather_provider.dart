import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_reate_weather_app/models/forecast_model.dart';
import 'package:flutter_reate_weather_app/models/weather_model.dart';
import 'package:flutter_reate_weather_app/services/location_service.dart';
import 'package:flutter_reate_weather_app/services/storage_service.dart';
import 'package:flutter_reate_weather_app/services/weather_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  // Section Code Block For For Forecasts
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherModel? _currentWeather;
  // Use for get full forecast
  List<ForecastModel> _fullForecast = [];
  // Use for get 5 days next
  List<ForecastModel> _dailyForecast = [];
  // Use for hourly forecast
  List<ForecastModel> get hourlyForecasts => _fullForecast;
  
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isCached = false; // Track nếu data là cached

  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
  );

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get dailyForecasts => _dailyForecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isCached => _isCached;

  int _getCacheAgeInMinutes() {
    if (_currentWeather?.cachedAt == null) return -1;
    final age = DateTime.now().difference(_currentWeather!.cachedAt!);
    return age.inMinutes;
  }

  void _processDailyForecast() {
    _dailyForecast = [];
    final Set<String> processedDates = {};
    
    final dateFormat = DateFormat('yyyy-MM-dd'); 

    for (var item in _fullForecast) {
      final dateStr = dateFormat.format(item.dateTime);
      
      if (!processedDates.contains(dateStr)) {
        processedDates.add(dateStr);
        _dailyForecast.add(item);
      }
    }
    if (_dailyForecast.length > 5) {
      _dailyForecast = _dailyForecast.sublist(0, 5);
    }
  }

  Future<void> initApp() async {
    await _storageService.clearCache();
    await fetchWeatherByLocation();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _fullForecast = await _weatherService.getForecast(cityName: cityName);
      
      _processDailyForecast();
      
      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = "Không tìm thấy thành phố hoặc lỗi mạng.";
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();

      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      _fullForecast = await _weatherService.getForecast(
        lat: position.latitude,
        lon: position.longitude,
      );

      _processDailyForecast();

      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
     
      await _handleFallback();
    }

    notifyListeners();
  }


  Future<void> _handleFallback() async {
    // Cố gắng load cached data
    final cachedWeather = await _storageService.getCachedWeather();

    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _isCached = true;
      
      // Tính tuổi cache và show message
      final ageMinutes = _getCacheAgeInMinutes();
      if (ageMinutes < 60) {
        _errorMessage = "📡 Offline - Dữ liệu từ ${ageMinutes} phút trước";
      } else if (ageMinutes < 1440) {
        final hours = ageMinutes ~/ 60;
        _errorMessage = "📡 Offline - Dữ liệu từ $hours giờ trước";
      } else {
        final days = ageMinutes ~/ 1440;
        _errorMessage = "📡 Offline - Dữ liệu từ $days ngày trước";
      }

      _state = WeatherState.loaded;
      return;
    }

    await fetchWeatherByCity("Ho Chi Minh");
  }

  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }


  bool _isCelsius = true;
  bool get isCelsius => _isCelsius;

  void toggleUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
  }

  double getTemperature(double tempInCelsius) {
    return _isCelsius ? tempInCelsius : (tempInCelsius * 9 / 5) + 32;
  }
  String get unitSymbol => _isCelsius ? "°C" : "°F";
}