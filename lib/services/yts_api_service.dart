import 'package:dio/dio.dart';
import '../models/movie.dart';

class YtsApiService {
  final Dio _dio = Dio();

  static const String _baseUrl = 'https://yts.mx/api/v2';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await _dio.get(
      '$_baseUrl/list_movies.json',
      queryParameters: {
        'query_term': query.trim(),
        'limit': 20,
      },
    );

    final data = response.data;

    if (data['status'] != 'ok') {
      throw Exception('Failed to search movies');
    }

    final movies = data['data']['movies'];

    if (movies == null) {
      return [];
    }

    return (movies as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }

  Future<List<Movie>> getMovies() async {
    final response = await _dio.get(
      '$_baseUrl/list_movies.json',
      queryParameters: {
        'limit': 50,
        'sort_by': 'date_added',
        'order_by': 'desc',
      },
    );

    final data = response.data;

    if (data['status'] != 'ok') {
      throw Exception('Failed to load movies');
    }

    final movies = data['data']['movies'];

    if (movies == null) {
      return [];
    }

    return (movies as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }

  Future<Movie?> getMovieById(int movieId) async {
    final response = await _dio.get(
      '$_baseUrl/movie_details.json',
      queryParameters: {
        'movie_id': movieId,
      },
    );

    final data = response.data;

    if (data['status'] != 'ok') {
      throw Exception('Failed to load movie');
    }

    final movieData = data['data']['movie'];

    if (movieData == null) {
      return null;
    }

    return Movie.fromJson(movieData);
  }
}
