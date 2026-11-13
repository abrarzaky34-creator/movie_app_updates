import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? movie;
  final List<Map<String, dynamic>> suggestions;

  const MovieDetailsState({
    this.isLoading = false,
    this.error,
    this.movie,
    this.suggestions = const [],
  });
}

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit() : super(const MovieDetailsState());

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://yts.lt/api/v2/',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<void> loadMovie(int movieId) async {
    emit(const MovieDetailsState(isLoading: true));

    try {
      // Load movie details
      final detailsResponse = await dio.get(
        'movie_details.json',
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
        },
      );

      final responseData = detailsResponse.data;

      if (responseData['status'] != 'ok') {
        throw Exception(
          responseData['status_message'] ?? 'Movie not found',
        );
      }

      final movieData = responseData['data']['movie'];

      if (movieData == null) {
        throw Exception('Movie data is empty');
      }

      final movie = Map<String, dynamic>.from(movieData);

      // Load movie suggestions
      List<Map<String, dynamic>> suggestions = [];

      try {
        final suggestionsResponse = await dio.get(
          'movie_suggestions.json',
          queryParameters: {
            'movie_id': movieId,
          },
        );

        final suggestionsData = suggestionsResponse.data;

        if (suggestionsData['status'] == 'ok') {
          final movies =
              suggestionsData['data']['movies'] ?? [];

          suggestions = List<Map<String, dynamic>>.from(
            movies.map(
                  (item) => Map<String, dynamic>.from(item),
            ),
          );
        }
      } catch (e) {
        debugPrint('Suggestions API Error: $e');
        suggestions = [];
      }

      emit(
        MovieDetailsState(
          movie: movie,
          suggestions: suggestions,
        ),
      );
    } on DioException catch (e) {
      debugPrint('========== MOVIE API ERROR ==========');
      debugPrint('Error type: ${e.type}');
      debugPrint('Error message: ${e.message}');
      debugPrint('Request URL: ${e.requestOptions.uri}');
      debugPrint('Status code: ${e.response?.statusCode}');
      debugPrint('Response data: ${e.response?.data}');
      debugPrint('======================================');

      emit(
        const MovieDetailsState(
          error: 'Failed to load movie details. Please try again.',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('MOVIE DETAILS ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      emit(
        const MovieDetailsState(
          error: 'Failed to load movie details. Please try again.',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    dio.close();
    return super.close();
  }
}