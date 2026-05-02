import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reate_weather_app/providers/settings_provider.dart';
import 'package:flutter_reate_weather_app/services/storage_service.dart';
import 'package:flutter_reate_weather_app/utils/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        title: Consumer<SettingsProvider>(
          builder: (context, settings, _) {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.settings, color: Colors.blueAccent),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.getString('settings_title', settings.language),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final t = (key) => AppLocalizations.getString(key, settings.language);

          return ListView(
            children: [
              // 🌡 TEMPERATURE UNIT
              SwitchListTile(
                title: Text(
                  t('temperature_unit'),
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Đơn vị nhiệt độ',
                  style: const TextStyle(color: Colors.white54),
                ),
                value: true,
                activeThumbColor: Colors.blueAccent,
                onChanged: (bool value) {
                  // TODO: Implement temperature unit toggle
                },
              ),

              const Divider(color: Colors.white24),

              // 🌪 WIND SPEED
              ListTile(
                title: Text(
                  t('wind_unit'),
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: DropdownButton<String>(
                  value: settings.windUnit,
                  dropdownColor: const Color(0xFF101922),
                  items: ['km/h', 'm/s', 'mph']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.changeWindUnit(value);
                    }
                  },
                ),
              ),

              SwitchListTile(
                title: Text(
                  t('hour_format'),
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  settings.is24Hour ? t('hour_24') : t('hour_12'),
                  style: const TextStyle(color: Colors.white54),
                ),
                value: settings.is24Hour,
                activeThumbColor: Colors.blueAccent,
                onChanged: (value) {
                  settings.toggleHourFormat(value);
                },
              ),

              ListTile(
                title: Text(
                  t('language'),
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: DropdownButton<String>(
                  value: settings.language,
                  dropdownColor: const Color(0xFF101922),
                  items: ['vi', 'en']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e == 'vi' ? 'Tiếng Việt' : 'English',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.changeLanguage(value);
                    }
                  },
                ),
              ),

              const Divider(color: Colors.white24),

              ListTile(
                title: Text(
                  t('clear_cache'),
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  t('clear_cache_desc'),
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: const Icon(Icons.delete, color: Colors.redAccent),
                onTap: () async {
                  final storageService = StorageService();
                  await storageService.init();
                  await storageService.clearCache();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t('cache_cleared')),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}