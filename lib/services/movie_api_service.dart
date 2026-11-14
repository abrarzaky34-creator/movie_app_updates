import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'api_constants.dart';
class MovieApiService {
  static const String baseUrl = ApiConstants.baseUrl;
  Future<List<Movie>> _fetchMovies(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies = data['data']?['movies'] as List? ?? [];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    }

    throw Exception('Failed to load movies');
  }
  Future<List<Movie>> getPopularMovies() {
    return _fetchMovies(
      Uri.parse(
        '$baseUrl/list_movies.json?sort_by=rating&order_by=desc&limit=20',
      ),
    );
  }
  Future<List<Movie>> getMoviesByCategory(String category) {
    return _fetchMovies(
      Uri.parse(
        '$baseUrl/list_movies.json?genre=${Uri.encodeComponent(category)}&limit=20',
      ),
    );
  }
  Future<List<Movie>> searchMovies(String query) {
    return _fetchMovies(
      Uri.parse(
        '$baseUrl/list_movies.json?query_term=${Uri.encodeComponent(query)}&limit=30',
      ),
    );
  }
  Future<List<Movie>> getAllMovies({int limit = 50}) {
    return _fetchMovies(
      Uri.parse('$baseUrl/list_movies.json?limit=$limit'),
    );
  }
}