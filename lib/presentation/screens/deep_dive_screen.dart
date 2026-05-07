import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/presentation/widgets/forecast/forecast_card.dart';
import 'package:technical_test/presentation/widgets/news/news_card.dart';
import 'package:technical_test/presentation/widgets/weather/weather_card.dart';
import '../../core/theme.dart';
import '../../models/country.dart';
import '../../providers/deep_dive_provider.dart';
import '../../providers/country_provider.dart';

class DeepDiveScreen extends StatefulWidget {
  const DeepDiveScreen({super.key});
  @override
  State<DeepDiveScreen> createState() => _DeepDiveScreenState();
}

class _DeepDiveScreenState extends State<DeepDiveScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cp = context.read<CountryProvider>();
      if (cp.countries.isEmpty) cp.loadAll();
    });
  }

  Future<void> _pickCountry() async {
    final picked = await Navigator.push<Country>(
      context,
      MaterialPageRoute(builder: (_) => const _CountryPickerScreen()),
    );
    if (picked != null && mounted) {
      context.read<DeepDiveProvider>().loadAll(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DeepDiveProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deep Dive'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.flag), text: 'Country'),
              Tab(icon: Icon(Icons.cloud), text: 'Weather'),
              Tab(icon: Icon(Icons.article), text: 'News'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _pickCountry,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public, color: AppTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            p.selectedCountry?.name ?? 'Select a country',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: p.selectedCountry == null
                  ? const _EmptyState()
                  : TabBarView(
                      children: [
                        _CountryTab(p: p),
                        _WeatherTab(p: p),
                        _NewsTab(p: p),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.public, size: 72, color: Color(0xFF6B7280)),
          const SizedBox(height: 16),
          Text(
            'Pick a country to load info, weather, and news.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    ),
  );
}

class _CountryPickerScreen extends StatefulWidget {
  const _CountryPickerScreen();
  @override
  State<_CountryPickerScreen> createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<_CountryPickerScreen> {
  final _ctrl = TextEditingController();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CountryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a country'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _ctrl,
              onChanged: p.search,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: p.countries.length,
              itemBuilder: (_, i) {
                final c = p.countries[i];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  elevation: 2,
                  shadowColor: AppTheme.primary.withValues(alpha: .1),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context, c),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              c.flagUrl,
                              width: 64,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.flag, size: 40),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            c.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _CountryTab extends StatelessWidget {
  final DeepDiveProvider p;
  const _CountryTab({required this.p});

  String _formatPop(int pop) {
    if (pop >= 1000000000) return '${(pop / 1000000000).toStringAsFixed(1)}B';
    if (pop >= 1000000) return '${(pop / 1000000).toStringAsFixed(1)}M';
    if (pop >= 1000) return '${(pop / 1000).toStringAsFixed(1)}K';
    return pop.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (p.loading) return const Center(child: CircularProgressIndicator());
    if (p.countryError != null) return _ErrorBox(p.countryError!);
    final c = p.countryDetail;
    if (c == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              c.flagUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(c.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.location_city,
            label: 'Capital',
            value: c.capital ?? 'N/A',
          ),
          _InfoTile(
            icon: Icons.attach_money,
            label: 'Currency',
            value: c.currency != null
                ? '${c.currency} (${c.currencySymbol ?? ''})'
                : 'N/A',
          ),
          _InfoTile(
            icon: Icons.language,
            label: 'Language',
            value: c.language ?? 'N/A',
          ),
          _InfoTile(
            icon: Icons.people,
            label: 'Population',
            value: _formatPop(c.population),
          ),
        ],
      ),
    );
  }
}

class _WeatherTab extends StatelessWidget {
  final DeepDiveProvider p;
  const _WeatherTab({required this.p});
  @override
  Widget build(BuildContext context) {
    if (p.loading) return const Center(child: CircularProgressIndicator());
    if (p.weatherError != null) return _ErrorBox(p.weatherError!);
    if (p.location == null || p.forecast == null)
      return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrentWeatherCard(
            location: p.location!,
            current: p.forecast!.current,
          ),
          const SizedBox(height: 24),
          Text(
            '7-Day Forecast',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: p.forecast!.daily.length,
              itemBuilder: (_, i) => ForecastCard(day: p.forecast!.daily[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsTab extends StatelessWidget {
  final DeepDiveProvider p;
  const _NewsTab({required this.p});
  @override
  Widget build(BuildContext context) {
    if (p.loading) return const Center(child: CircularProgressIndicator());
    if (p.newsError != null) return _ErrorBox(p.newsError!);
    if (p.news.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.article_outlined,
                size: 72,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(height: 16),
              Text(
                'No news available for this country.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: p.news.length,
      itemBuilder: (_, i) => NewsCard(article: p.news[i]),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: .07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 3),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox(this.message);
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Color(0xFF6B7280)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    ),
  );
}
