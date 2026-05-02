import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/weather_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'screens/main_screen.dart';
import 'package:flutter_reate_weather_app/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('vi_VN', null);

  final storageService = StorageService();
  await storageService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherService(),
            LocationService(),
            storageService,
          ),
        ),

        
        ChangeNotifierProvider(
          create: (_) {
            final provider = SettingsProvider(storageService);
            provider.loadSettings();
            return provider;
          },
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale(settings.language),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}