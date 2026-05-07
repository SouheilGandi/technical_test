class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    temperature: (json['temperature_2m'] as num).toDouble(),
    windSpeed: (json['wind_speed_10m'] as num).toDouble(),
    weatherCode: json['weather_code'] as int,
  );
}

class ForecastDay {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int weatherCode;

  ForecastDay({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherCode,
  });
}

class WeatherForecast {
  final CurrentWeather current;
  final List<ForecastDay> daily;

  WeatherForecast({required this.current, required this.daily});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(
      json['current'] as Map<String, dynamic>,
    );
    final daily = json['daily'] as Map<String, dynamic>;
    final times = (daily['time'] as List).cast<String>();
    final maxes = (daily['temperature_2m_max'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final mins = (daily['temperature_2m_min'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final codes = (daily['weather_code'] as List).map((e) => e as int).toList();

    final days = <ForecastDay>[];
    for (var i = 0; i < times.length; i++) {
      days.add(
        ForecastDay(
          date: DateTime.parse(times[i]),
          minTemp: mins[i],
          maxTemp: maxes[i],
          weatherCode: codes[i],
        ),
      );
    }
    return WeatherForecast(current: current, daily: days);
  }
}
