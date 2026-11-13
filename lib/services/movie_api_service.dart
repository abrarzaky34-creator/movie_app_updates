import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApiService {
  static const String baseUrl = 'https://movies-api.accel.li/api/v2';

  Future<List<Movie>> getPopularMovies() async {
    final url = Uri.parse(
      '$baseUrl/list_movies.json?sort_by=rating&order_by=desc&limit=20',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = data['data']?['movies'] as List? ?? [];

      return movies
          .map((movie) => Movie.fromJson(movie))
          .toList();
    }

    throw Exception('Failed to load movies');
  }

  Future<List<Movie>> getMoviesByCategory(String category) async {
    final url = Uri.parse(
      '$baseUrl/list_movies.json?genre=${Uri.encodeComponent(category)}&limit=20',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = data['data']?['movies'] as List? ?? [];
      return movies
          .map((movie) => Movie.fromJson(movie))
          .toList();
    }

    throw Exception('Failed to load movies');
  }
}