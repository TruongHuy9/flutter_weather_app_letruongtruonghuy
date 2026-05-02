class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = "8de596f3e6f3f68d94d745e4d024773c";

  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    params['appid'] = apiKey;
    params['units'] = 'metric';
    params['lang'] = 'vi';

    final query = params.entries
        .map((e) => "${e.key}=${e.value}")
        .join("&");

    return "$baseUrl$endpoint?$query";
  }
}