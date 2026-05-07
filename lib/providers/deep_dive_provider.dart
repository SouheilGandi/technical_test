import 'package:flutter/material.dart';
import 'package:technical_test/services/geo_coding_services.dart';
import 'package:technical_test/services/weather_services.dart';
import '../models/country.dart';
import '../models/news_article.dart';
import '../models/geo_location.dart';
import '../models/weather_forecast.dart';
import '../services/country_service.dart';
import '../services/news_service.dart';

class DeepDiveProvider extends ChangeNotifier {
  final _countryService = CountryService();
  final _geoService = GeocodingService();
  final _weatherService = WeatherService();
  final _newsService = NewsService();

  Country? selectedCountry;
  Country? countryDetail;
  GeoLocation? location;
  WeatherForecast? forecast;
  List<NewsArticle> news = [];

  bool loading = false;
  String? countryError, weatherError, newsError;

  Future<void> loadAll(Country country) async {
    selectedCountry = country;
    loading = true;
    countryDetail = null;
    forecast = null;
    location = null;
    news = [];
    countryError = null;
    weatherError = null;
    newsError = null;
    notifyListeners();

    // 3 calls IN PARALLEL — each isolates its own errors
    await Future.wait([
      _loadCountry(country.code),
      _loadWeather(country.capital ?? country.name),
      _loadNews(country.code),
    ]);

    loading = false;
    notifyListeners();
  }

  Future<void> _loadCountry(String code) async {
    try {
      countryDetail = await _countryService.getCountryByCode(code);
    } catch (_) {
      countryError = 'Failed to load country info.';
    }
  }

  Future<void> _loadWeather(String capital) async {
    try {
      location = await _geoService.resolveCity(capital);
      forecast = await _weatherService.fetch(
        location!.latitude,
        location!.longitude,
      );
    } catch (_) {
      weatherError = 'Failed to load weather.';
    }
  }

  Future<void> _loadNews(String code) async {
    try {
      news = await _newsService.getTopHeadlines(code);
    } catch (_) {
      newsError = 'Failed to load news.';
    }
  }
}
