import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/presentation/screens/weather/weather_screen.dart';
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
      ],
      child: MaterialApp(
        title: 'WorldScope',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const WeatherScreen(),
      ),
    );
  }
}
