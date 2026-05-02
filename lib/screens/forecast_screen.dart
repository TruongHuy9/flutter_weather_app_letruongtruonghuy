import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reate_weather_app/providers/weather_provider.dart';
import 'package:flutter_reate_weather_app/widgets/current_weather_card.dart';
import 'package:flutter_reate_weather_app/widgets/error_widget.dart';
import 'package:flutter_reate_weather_app/widgets/hourly_forecast_list.dart';
import 'package:flutter_reate_weather_app/widgets/loading_shimmer.dart';
import 'package:flutter_reate_weather_app/widgets/weather_detail_item.dart';
import 'package:intl/intl.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101922),

      appBar: AppBar(
        backgroundColor: Color(0xFF101922),
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            final weather = provider.currentWeather;

            if (weather == null) {
              return const Text(
                "Weather App",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            return Row(
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
            );
          },
        ),
        centerTitle: true,

        actions: const [SizedBox(width: kToolbarHeight)],
      ),

      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            // State Loading
            if (provider.state == WeatherState.loading) {
              return const LoadingShimmer();
            }

            // Sate Error
            if (provider.state == WeatherState.error) {
              return ErrorWidgetCustom(
                message: provider.errorMessage,
                onRetry: () => provider.fetchWeatherByLocation(),
              );
            }

            // Sate No Data
            if (provider.currentWeather == null) {
              return const Center(
                child: Text(
                  'Chưa có dữ liệu',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Sate Normal
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (provider.currentWeather != null) ...[
                        CurrentWeatherCard(weather: provider.currentWeather!),
                        SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(
                              child: WeatherDetailsSection(
                                title: "Áp Suất",
                                icon: Icons.compress,
                                value: "${provider.currentWeather!.pressure} hPa",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: WeatherDetailsSection(
                                title: "UV Index",
                                icon: Icons.wb_sunny,
                                value: "${provider.currentWeather!.uvi?.toStringAsFixed(1) ?? 'N/A'}",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: WeatherDetailsSection(
                                title: "Mặt Trời",
                                icon: Icons.light_mode,
                                value: "${_formatTime(provider.currentWeather!.sunrise)}\n${_formatTime(provider.currentWeather!.sunset)}",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),

                        HourlyForecastList(
                          hourlyForecasts: provider.hourlyForecasts,
                        ),
                        SizedBox(height: 16),
                      ]
                    ]
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTime(int unixTimestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat('HH:mm').format(dateTime);
  }
}
