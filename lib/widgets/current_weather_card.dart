import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_reate_weather_app/models/weather_model.dart';
import 'package:flutter_reate_weather_app/screens/forecast_screen.dart';
import 'package:flutter_reate_weather_app/widgets/weather_detail_item.dart';
import 'package:flutter_reate_weather_app/utils/date_formatter.dart';
import 'package:flutter_reate_weather_app/utils/weather_icon_helper.dart';
import 'package:flutter_reate_weather_app/providers/settings_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel? weather;
  final bool isLoading;

  const CurrentWeatherCard({
    super.key,
    this.weather,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildShimmer();

    if (weather == null) {
      return const SizedBox();
    }

    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final settings = context.watch<SettingsProvider>(); 
    final icon = weather!.icon;

    String formattedTime;
    if (settings.is24Hour) {
      formattedTime = DateFormatter.formatFull(weather!.dateTime);
    } else {
      formattedTime = DateFormatter.format12Hour(weather!.dateTime);
    }

    double wind = weather!.windSpeed;
    String unit = settings.windUnit;

    if (unit == 'm/s') {
      wind = wind / 3.6;
    } else if (unit == 'mph') {
      wind = wind * 0.621371;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        if (icon.isNotEmpty)
          Icon(
            WeatherIconHelper.getIconFromCode(weather!.icon),
            size: 100,
            color: Colors.white,
          )
        else
          const Icon(Icons.cloud, size: 80, color: Colors.grey),

        const SizedBox(height: 10),

        Text(
          '${weather!.temperature.round()}°',
          style: const TextStyle(
            fontSize: 80,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          weather!.description,
          style: const TextStyle(
            fontSize: 21,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thấp: ${weather!.tempMin}°',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Text(
              'Cao: ${weather!.tempMax}°',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: 10),

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForecastScreen()),
            );
          },
          child: const Text(
            "Chi Tiết Hôm Nay",
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ),

        const SizedBox(height: 25),

        Row(
          children: [
            Expanded(
              child: WeatherDetailsSection(
                title: "Gió",
                icon: Icons.wind_power,
                value: "${wind.toStringAsFixed(1)} $unit",
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: WeatherDetailsSection(
                title: "Cảm Giác",
                icon: Icons.thermostat,
                value: "${weather!.feelsLike}°",
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: WeatherDetailsSection(
                title: "Độ Ẩm",
                icon: Icons.water_drop,
                value: "${weather!.humidity} %",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    Color shimmerColor = Colors.grey[800]!;

    return Column(
      children: [
        Container(height: 20, width: 200, color: shimmerColor),
        const SizedBox(height: 10),

        Container(height: 120, width: 120, color: shimmerColor),
        const SizedBox(height: 10),

        Container(height: 80, width: 100, color: shimmerColor),
        const SizedBox(height: 10),

        Container(height: 20, width: 120, color: shimmerColor),
        const SizedBox(height: 10),

        Container(height: 20, width: 200, color: shimmerColor),
        const SizedBox(height: 20),

        Container(height: 20, width: 150, color: shimmerColor),
        const SizedBox(height: 25),

        Row(
          children: [
            Expanded(child: Container(height: 100, color: shimmerColor)),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 100, color: shimmerColor)),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 100, color: shimmerColor)),
          ],
        ),
      ],
    );
  }
}