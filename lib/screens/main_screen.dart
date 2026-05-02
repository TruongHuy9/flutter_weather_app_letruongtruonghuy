import 'package:flutter/material.dart';
import 'package:flutter_reate_weather_app/screens/home_screen.dart';
import 'package:flutter_reate_weather_app/screens/search_screen.dart';
import 'package:flutter_reate_weather_app/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      SearchScreen(
        onSearchSuccess: () {
          _switchTab(0);
        },
      ),

      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _switchTab,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
