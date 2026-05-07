class Country {
  final String name;
  final String? capital;
  final String? currency;
  final String? currencySymbol;
  final String? language;
  final int population;
  final String flagUrl;
  final String code;

  Country({
    required this.name,
    this.capital,
    this.currency,
    this.currencySymbol,
    this.language,
    required this.population,
    required this.flagUrl,
    required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    // Capital
    final caps = json['capital'] as List?;
    final capital = (caps != null && caps.isNotEmpty)
        ? caps.first as String
        : null;

    // Currency
    String? currency, currencySymbol;
    final currencies = json['currencies'] as Map<String, dynamic>?;
    if (currencies != null && currencies.isNotEmpty) {
      final first = currencies.values.first as Map<String, dynamic>;
      currency = first['name'] as String?;
      currencySymbol = first['symbol'] as String?;
    }

    // Language
    String? language;
    final languages = json['languages'] as Map<String, dynamic>?;
    if (languages != null && languages.isNotEmpty) {
      language = languages.values.first as String?;
    }

    return Country(
      name: json['name']?['common'] ?? 'Unknown',
      capital: capital,
      currency: currency,
      currencySymbol: currencySymbol,
      language: language,
      population: json['population'] ?? 0,
      flagUrl: json['flags']?['png'] ?? '',
      code: json['cca2'] ?? '',
    );
  }
}
