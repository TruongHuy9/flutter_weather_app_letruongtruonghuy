import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_reate_weather_app/config/api_config.dart';
import 'package:flutter_reate_weather_app/models/forecast_model.dart';
import 'package:flutter_reate_weather_app/models/weather_model.dart';

class WeatherService {
  WeatherService();

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {'q': cityName});
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon) async {
    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }

  Future<List<ForecastModel>> getForecast({String? cityName, double? lat, double? lon}) async {
    Map<String, dynamic> params = {};
    
    if (cityName != null) {
      params['q'] = cityName;
    } else if (lat != null && lon != null) {
      params['lat'] = lat.toString();
      params['lon'] = lon.toString();
    } else {
      throw Exception("Missing location data");
    }

    final url = ApiConfig.buildUrl(ApiConfig.forecast, params);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecastList = data['list'];
      return forecastList.map((item) => ForecastModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load forecast: ${response.statusCode}');
    }
  }

  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}