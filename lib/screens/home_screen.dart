import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reate_weather_app/providers/weather_provider.dart';
import 'package:flutter_reate_weather_app/providers/settings_provider.dart';
import 'package:flutter_reate_weather_app/widgets/current_weather_card.dart';
import 'package:flutter_reate_weather_app/widgets/daily_forecast_card.dart';
import 'package:flutter_reate_weather_app/widgets/error_widget.dart';
import 'package:flutter_reate_weather_app/screens/weekly_forecast_screen.dart';
import 'package:flutter_reate_weather_app/utils/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
    void initState() {
      super.initState();

      Future.microtask(() {
        _initLocation();
      });
    }


  Future<void> _initLocation() async {
    final provider = context.read<WeatherProvider>();

    try {
      await provider.fetchWeatherByLocation(); // GPS
    } catch (e) {
      await provider.fetchWeatherByCity("Ho Chi Minh"); 
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        centerTitle: true,
        title: Consumer2<WeatherProvider, SettingsProvider>(
          builder: (context, provider, settings, _) {
            final weather = provider.currentWeather;
            final t = (key) => AppLocalizations.getString(key, settings.language);

            if (weather == null) {
              return Text(
                t('weather_app'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text(
                      "${weather.cityName}, ${weather.country}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
               
                if (provider.isCached)
                  Text(
                    t('offline'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            );
          },
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer2<WeatherProvider, SettingsProvider>(
          builder: (context, provider, settings, child) {
            final t = (key) => AppLocalizations.getString(key, settings.language);
            
            if (provider.state == WeatherState.error) {
              return ErrorWidgetCustom(
                message: provider.errorMessage,
                onRetry: () => provider.fetchWeatherByLocation(),
              );
            }

            if (provider.currentWeather == null &&
                provider.state != WeatherState.loading) {
              return Center(
                child: Text(
                  t('no_data'),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Show cached/offline message
                      if (provider.isCached && provider.errorMessage.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange[900],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange[700]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  provider.errorMessage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Current Weather
                      CurrentWeatherCard(
                        weather: provider.currentWeather,
                        isLoading:
                            provider.state == WeatherState.loading,
                      ),

                      const SizedBox(height: 25),

                      // Title
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t('forecast_5days'),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WeeklyForecastScreen(),
                                ),
                              );
                            },
                            child: Text(
                              t('view_more'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      ...List.generate(
                        provider.state == WeatherState.loading
                            ? 3
                            : provider.dailyForecasts.length,
                        (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10),
                            child: DailyForecastCard(
                              weather:
                                  provider.state == WeatherState.loading
                                      ? null
                                      : provider.dailyForecasts[index],
                              isLoading:
                                  provider.state == WeatherState.loading,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}