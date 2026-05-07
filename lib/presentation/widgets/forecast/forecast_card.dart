import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technical_test/core/theme.dart';
import 'package:technical_test/core/wmo.dart';
import 'package:technical_test/models/weather_forecast.dart';

class ForecastCard extends StatelessWidget {
  final ForecastDay day;
  const ForecastCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final info = WmoCodes.info(day.weatherCode);
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: .07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEE').format(day.date),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            DateFormat('MMM d').format(day.date),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Icon(info.icon, color: AppTheme.primary, size: 36),
          const SizedBox(height: 8),
          Text(
            info.label,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day.maxTemp.round()}°',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${day.minTemp.round()}°',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
