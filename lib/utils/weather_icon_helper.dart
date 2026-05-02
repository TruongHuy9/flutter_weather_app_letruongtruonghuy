import 'package:flutter/material.dart';

class WeatherIconHelper {
  // Mapping từ icon code của OpenWeatherMap
  static IconData getIconFromCode(String iconCode) {
    // Xóa suffix d/n để lấy chỉ số chính
    final code = iconCode.replaceAll(RegExp(r'[dn]$'), '');
    
    switch (code) {
      case '01': // Clear sky
        return Icons.wb_sunny;
      case '02': // Few clouds
        return Icons.wb_cloudy;
      case '03': // Scattered clouds
        return Icons.cloud;
      case '04': // Broken clouds
        return Icons.cloud;
      case '09': // Shower rain
        return Icons.grain;
      case '10': // Rain
        return Icons.water_drop;
      case '11': // Thunderstorm
        return Icons.flash_on;
      case '13': // Snow
        return Icons.ac_unit;
      case '50': // Mist
        return Icons.blur_on;
      default:
        return Icons.cloud;
    }
  }

  // Fallback: mapping từ mainCondition text
  static IconData getIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;

      case 'clouds':
        return Icons.cloud;

      case 'rain':
      case 'drizzle':
        return Icons.grain;

      case 'thunderstorm':
        return Icons.flash_on;

      case 'snow':
        return Icons.ac_unit;

      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on;

      default:
        return Icons.cloud;
    }
  }
}