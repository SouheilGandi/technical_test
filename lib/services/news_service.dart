import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/news_article.dart';

class NewsService {
  static const _base = 'https://newsapi.org/v2/top-headlines';

  Future<List<NewsArticle>> getTopHeadlines(String countryCode) async {
    final uri = Uri.parse(
      '$_base?country=${countryCode.toLowerCase()}&pageSize=5&apiKey=${ApiKeys.newsApi}',
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final list = (data['articles'] as List?) ?? [];
      return list
          .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('News fetch failed (${res.statusCode})');
  }
}
