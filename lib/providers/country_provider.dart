import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';

class CountryProvider extends ChangeNotifier {
  final _service = CountryService();

  List<Country> _all = [];
  List<Country> _filtered = [];
  Country? selected;
  bool loading = false;
  String? error;

  List<Country> get countries => _filtered;

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      _all = await _service.getAllCountries();
      _filtered = _all;
    } catch (_) {
      error = 'Failed to load countries. Check your connection.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _filtered = query.isEmpty
        ? _all
        : _all
              .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    notifyListeners();
  }

  Future<void> loadDetail(String code) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      //debugPrint('Selected country: ${selected?.name}');

      selected = await _service.getCountryByCode(code);
      debugPrint('Selected country: ${selected?.name}');
    } catch (_) {
      error = 'Failed to load details. Check your connection.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
