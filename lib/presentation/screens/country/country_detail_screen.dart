import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../providers/country_provider.dart';
import '../../../models/country.dart';

class CountryDetailScreen extends StatefulWidget {
  final String code;
  const CountryDetailScreen({super.key, required this.code});

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(
        context,
        listen: false,
      ).loadDetail(widget.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CountryProvider>();

    if (provider.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null || provider.selected == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 72,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(height: 16),
                Text(
                  provider.error ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<CountryProvider>().loadDetail(widget.code),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final country = provider.selected!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(country),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Country Details',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  _InfoTile(
                    icon: Icons.location_city_rounded,
                    label: 'Capital',
                    value: country.capital ?? 'N/A',
                  ),
                  _InfoTile(
                    icon: Icons.attach_money_rounded,
                    label: 'Currency',
                    value: _currencyText(country),
                  ),
                  _InfoTile(
                    icon: Icons.language_rounded,
                    label: 'Language',
                    value: country.language ?? 'N/A',
                  ),
                  _InfoTile(
                    icon: Icons.people_rounded,
                    label: 'Population',
                    value: _formatPop(country.population),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Country country) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          country.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              country.flagUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppTheme.primary),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.primary.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _currencyText(Country c) {
    if (c.currency == null) return 'N/A';
    return c.currencySymbol != null
        ? '${c.currency} (${c.currencySymbol})'
        : c.currency!;
  }

  String _formatPop(int pop) {
    if (pop >= 1000000000) return '${(pop / 1000000000).toStringAsFixed(1)}B';
    if (pop >= 1000000) return '${(pop / 1000000).toStringAsFixed(1)}M';
    if (pop >= 1000) return '${(pop / 1000).toStringAsFixed(1)}K';
    return pop.toString();
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
