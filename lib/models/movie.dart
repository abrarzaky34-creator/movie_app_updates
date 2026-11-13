class Movie {
  final int id;
  final String title;
  final String titleEnglish;
  final int year;
  final double rating;
  final int runtime;
  final List<String> genres;
  final String summary;
  final String descriptionFull;
  final String mediumCoverImage;
  final String largeCoverImage;
  final String backgroundImage;
  final String ytTrailerCode;

  Movie({
    required this.id,
    required this.title,
    required this.titleEnglish,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.genres,
    required this.summary,
    required this.descriptionFull,
    required this.mediumCoverImage,
    required this.largeCoverImage,
    required this.backgroundImage,
    required this.ytTrailerCode,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      titleEnglish: json['title_english'] ?? json['title'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      summary: json['summary'] ?? '',
      descriptionFull: json['description_full'] ?? '',
      mediumCoverImage: json['medium_cover_image'] ?? '',
      largeCoverImage: json['large_cover_image'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      ytTrailerCode: json['yt_trailer_code'] ?? '',
    );
  }
}
