class AppLocalizations {
  static final Map<String, Map<String, String>> _localizedStrings = {
    'vi': {
      // Settings
      'settings_title': 'Cài Đặt Đơn Vị Đo',
      'temperature_unit': 'Đơn vị đo độ C (°C)',
      'using_celsius': 'Đang dùng độ C',
      'using_fahrenheit': 'Đang dùng độ F',
      'wind_unit': 'Đơn vị tốc độ gió',
      'hour_format': 'Định dạng 24 giờ',
      'hour_24': '24h',
      'hour_12': '12h (AM/PM)',
      'language': 'Ngôn ngữ',
      'clear_cache': 'Xóa bộ nhớ cache',
      'clear_cache_desc': 'Xóa dữ liệu thời tiết đã lưu',
      'cache_cleared': 'Cache đã xóa! App sẽ load lại...',

      // Home
      'weather_app': 'Weather App',
      'no_data': 'Chưa có dữ liệu',
      'forecast_5days': 'Dự Báo 5 Ngày Tới',
      'view_more': 'Xem Thêm',
      'details_today': 'Chi Tiết Hôm Nay',
      'offline': '📡 Offline',
      'offline_data': 'Dữ liệu từ',
      'min_ago': 'phút trước',
      'hour_ago': 'giờ trước',
      'day_ago': 'ngày trước',

      // Search
      'search_title': 'Tìm Kiếm',
      'search_hint': 'Nhập tên thành phố...',
      'search_button': 'Tìm kiếm',
      'found': 'Đã tìm thấy',
      'not_found': 'Không tìm thấy thành phố',
      'favorite_cities': '⭐ Thành Phố Yêu Thích',
      'recent_searches': '🕐 Tìm Kiếm Gần Đây',
      'clear_history': 'Xóa',
      'no_recent': 'Không có tìm kiếm gần đây',
      'added_favorite': 'Đã thêm vào yêu thích',
      'removed_favorite': 'Đã xóa khỏi yêu thích',
      'favorite_limit': 'Đã đạt giới hạn 5 thành phố yêu thích',

      // Weather details
      'wind': 'Gió',
      'feels_like': 'Cảm Giác',
      'humidity': 'Độ Ẩm',
      'pressure': 'Áp Suất',
      'uv_index': 'UV Index',
      'sunrise_sunset': 'Mặt Trời',
      'high': 'Cao',
      'low': 'Thấp',
      'light_rain': 'mưa nhẹ',
      'moderate_rain': 'mưa đến u ám',
      'cloudy': 'mây',
    },
    'en': {
      // Settings
      'settings_title': 'Settings',
      'temperature_unit': 'Temperature Unit (°C)',
      'using_celsius': 'Using Celsius',
      'using_fahrenheit': 'Using Fahrenheit',
      'wind_unit': 'Wind Speed Unit',
      'hour_format': '24-hour Format',
      'hour_24': '24h',
      'hour_12': '12h (AM/PM)',
      'language': 'Language',
      'clear_cache': 'Clear Cache',
      'clear_cache_desc': 'Clear saved weather data',
      'cache_cleared': 'Cache cleared! App will reload...',

      // Home
      'weather_app': 'Weather App',
      'no_data': 'No data available',
      'forecast_5days': '5-Day Forecast',
      'view_more': 'View More',
      'details_today': 'Today Details',
      'offline': '📡 Offline',
      'offline_data': 'Data from',
      'min_ago': 'minutes ago',
      'hour_ago': 'hours ago',
      'day_ago': 'days ago',

      // Search
      'search_title': 'Search',
      'search_hint': 'Enter city name...',
      'search_button': 'Search',
      'found': 'Found',
      'not_found': 'City not found',
      'favorite_cities': '⭐ Favorite Cities',
      'recent_searches': '🕐 Recent Searches',
      'clear_history': 'Clear',
      'no_recent': 'No recent searches',
      'added_favorite': 'Added to favorites',
      'removed_favorite': 'Removed from favorites',
      'favorite_limit': 'Reached limit of 5 favorite cities',

      // Weather details
      'wind': 'Wind',
      'feels_like': 'Feels Like',
      'humidity': 'Humidity',
      'pressure': 'Pressure',
      'uv_index': 'UV Index',
      'sunrise_sunset': 'Sunrise/Sunset',
      'high': 'High',
      'low': 'Low',
      'light_rain': 'light rain',
      'moderate_rain': 'light to moderate rain',
      'cloudy': 'cloudy',
    },
  };

  static String getString(String key, String language) {
    return _localizedStrings[language]?[key] ?? _localizedStrings['en']?[key] ?? key;
  }
}
