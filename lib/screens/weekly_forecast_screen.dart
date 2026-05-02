import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reate_weather_app/providers/weather_provider.dart';
import 'package:flutter_reate_weather_app/widgets/daily_forecast_card.dart';

class WeeklyForecastScreen extends StatelessWidget {
  const WeeklyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF101922),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        centerTitle: true,
        title: const Text(
          "Dự báo 5 ngày",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: provider.dailyForecasts.isEmpty
          ? const Center(
              child: Text(
                "Không có dữ liệu",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.dailyForecasts.length,
              itemBuilder: (context, index) {
                final item = provider.dailyForecasts[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DailyForecastCard(
                    weather: item,
                    isLoading: false,
                  ),
                );
              },
            ),
    );
  }
}