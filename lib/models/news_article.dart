class NewsArticle {
  final String title;
  final String? description;
  final String? source;
  final String? imageUrl;
  final String url;

  NewsArticle({
    required this.title,
    required this.url,
    this.description,
    this.source,
    this.imageUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
    title: json['title'] ?? 'Untitled',
    description: json['description'],
    source: json['source']?['name'],
    imageUrl: json['urlToImage'],
    url: json['url'] ?? '',
  );
}
