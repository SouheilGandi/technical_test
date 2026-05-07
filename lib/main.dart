import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/country_provider.dart';
import 'presentation/screens/country_list_screen.dart';

void main() => runApp(const WorldScopeApp());

class WorldScopeApp extends StatelessWidget {
  const WorldScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CountryProvider())],
      child: MaterialApp(
        title: 'WorldScope',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const CountryListScreen(),
      ),
    );
  }
}
