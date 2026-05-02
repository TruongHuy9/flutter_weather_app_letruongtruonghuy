import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reate_weather_app/providers/weather_provider.dart';
import 'package:flutter_reate_weather_app/providers/settings_provider.dart';
import 'package:flutter_reate_weather_app/services/storage_service.dart';
import 'package:flutter_reate_weather_app/utils/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback? onSearchSuccess;

  const SearchScreen({super.key, this.onSearchSuccess});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late StorageService _storageService;
  bool _isLoading = false;
  List<String> _recentSearches = [];
  List<String> _favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _storageService = StorageService();
    _loadData();
  }

  Future<void> _loadData() async {
    await _storageService.init();
    final recent = await _storageService.getRecentSearches();
    final favorites = await _storageService.getFavoriteCities();
    
    setState(() {
      _recentSearches = recent;
      _favoriteCities = favorites;
    });
  }

  void _submitSearch(String cityName) async {
    if (cityName.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await context.read<WeatherProvider>().fetchWeatherByCity(cityName);
      
      // Lưu recent search
      await _storageService.addRecentSearch(cityName);
      await _loadData(); // Refresh danh sách

      if (!mounted) return;

      final settings = context.read<SettingsProvider>();
      final t = (key) => AppLocalizations.getString(key, settings.language);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${t('found')}: $cityName"),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.onSearchSuccess != null) {
        widget.onSearchSuccess!();
      }
    } catch (e) {
      if (!mounted) return;
      final settings = context.read<SettingsProvider>();
      final t = (key) => AppLocalizations.getString(key, settings.language);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${t('not_found')}: $cityName"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(String cityName) async {
    final isFav = await _storageService.isFavorite(cityName);
    final settings = context.read<SettingsProvider>();
    final t = (key) => AppLocalizations.getString(key, settings.language);
    
    if (isFav) {
      await _storageService.removeFavoriteCity(cityName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('removed_favorite')),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      final added = await _storageService.addFavoriteCity(cityName);
      if (mounted) {
        if (added) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t('added_favorite')),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t('favorite_limit')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Consumer<SettingsProvider>(
          builder: (context, settings, _) {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search, color: Colors.blueAccent),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.getString('search_title', settings.language),
                    style: const TextStyle(
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
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SEARCH BAR
                  TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: t('search_hint'),
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF1c2632),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () => _controller.clear(),
                      ),
                    ),
                    onSubmitted: (_) => _submitSearch(_controller.text.trim()),
                  ),
                  const SizedBox(height: 16),

                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () => _submitSearch(_controller.text.trim()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            t('search_button'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                  const SizedBox(height: 30),

                  // FAVORITE CITIES
                  if (_favoriteCities.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t('favorite_cities'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_favoriteCities.length}/5",
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _favoriteCities.map((city) {
                        return GestureDetector(
                          onTap: () => _submitSearch(city),
                          child: Chip(
                            label: Text(city),
                            labelStyle: const TextStyle(color: Colors.white),
                            backgroundColor: Colors.amber,
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () => _toggleFavorite(city),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // RECENT SEARCHES
                  if (_recentSearches.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t('recent_searches'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _storageService.clearRecentSearches();
                            await _loadData();
                          },
                          child: Text(
                            t('clear_history'),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recentSearches.length,
                      itemBuilder: (context, index) {
                        final city = _recentSearches[index];
                        final isFav = _favoriteCities.contains(city);
                        
                        return ListTile(
                          leading: const Icon(Icons.history, color: Colors.blue),
                          title: Text(
                            city,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : Colors.white54,
                            ),
                            onPressed: () => _toggleFavorite(city),
                          ),
                          onTap: () => _submitSearch(city),
                        );
                      },
                    ),
                  ] else ...[
                    Center(
                      child: Text(
                        t('no_recent'),
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
