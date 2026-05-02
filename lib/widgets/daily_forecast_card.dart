import 'package:flutter/material.dart';
import 'package:flutter_reate_weather_app/models/forecast_model.dart';

class DailyForecastCard extends StatelessWidget {
  final ForecastModel? weather;
  final bool isLoading;

  const DailyForecastCard({
    super.key,
    this.weather,
    this.isLoading = false, 
  });

  @override
  Widget build(BuildContext context) {
    // 👉 Loading UI
    if (isLoading) {
      return _buildShimmer();
    }

    // 👉 No data
    if (weather == null) {
      return const SizedBox();
    }

    // 👉 Normal UI
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2635),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Image.network(
            "https://openweathermap.org/img/wn/${weather!.icon}@2x.png",
            width: 50,
          ),

          const SizedBox(width: 12),

          // Date + Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${weather!.dateTime.day}/${weather!.dateTime.month}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  weather!.description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Temp
          Text(
            "${weather!.tempMin}° / ${weather!.tempMax}°",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2635),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(width: 50, height: 50, color: Colors.grey[800]),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 100, color: Colors.grey[800]),
                const SizedBox(height: 6),
                Container(height: 12, width: 80, color: Colors.grey[800]),
              ],
            ),
          ),

          Container(width: 50, height: 14, color: Colors.grey[800]),
        ],
      ),
    );
  }
}