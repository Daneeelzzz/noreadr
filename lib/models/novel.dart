// models/novel.dart
class Novel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String? coverImage;
  final double rating;
  final List<String> genreIds; // For relation (multiple) genres
  final int reviews; // Added reviews field
  final int chapters; // Added chapters field, if used

  Novel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.coverImage,
    required this.rating,
    required this.genreIds,
    this.reviews = 0, // Default to 0 if not provided
    this.chapters = 0, // Default to 0 if not provided
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    final genreIds = json['genres'] is List
        ? (json['genres'] as List).map((g) => g['id'].toString()).toList()
        : <String>[];
    return Novel(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'Unknown',
      description: json['description'] ?? '',
      coverImage: json['cover_image'] != null
          ? 'http://127.0.0.1:8090/api/files/novels/${json['id']}/${json['cover_image']}'
          : null,
      rating: (json['rating'] ?? 0.0).toDouble(),
      genreIds: genreIds,
      reviews: int.tryParse(json['reviews']?.toString() ?? '0') ?? 0,
      chapters: int.tryParse(json['chapters']?.toString() ?? '0') ?? 0,
    );
  }
}