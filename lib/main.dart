import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/presentation/screens/deep_dive_screen.dart';
import 'package:technical_test/presentation/screens/weather/weather_screen.dart';
import 'package:technical_test/providers/deep_dive_provider.dart';
import 'package:technical_test/providers/weather_provider.dart';
import 'core/theme.dart';
import 'providers/country_provider.dart';
import 'presentation/screens/country/country_list_screen.dart';

void main() => runApp(const WorldScopeApp());

class WorldScopeApp extends StatelessWidget {
  const WorldScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => DeepDiveProvider()),
      ],
      child: MaterialApp(
        title: 'WorldScope',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const HomeShell(),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _screens = const [
    CountryListScreen(),
    WeatherScreen(),
    DeepDiveScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.public), label: 'Countries'),
          NavigationDestination(icon: Icon(Icons.cloud), label: 'Weather'),
          NavigationDestination(
            icon: Icon(Icons.travel_explore),
            label: 'Deep Dive',
          ),
        ],
      ),
    );
  }
}
