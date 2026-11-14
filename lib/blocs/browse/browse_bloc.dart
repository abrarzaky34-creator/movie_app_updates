import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/yts_api_service.dart';
import '../../models/movie.dart';
import 'browse_event.dart';
import 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final YtsApiService _apiService;
  List<Movie> _allMovies = [];

  BrowseBloc({YtsApiService? apiService})
      : _apiService = apiService ?? YtsApiService(),
        super(BrowseInitial()) {
    on<LoadBrowseMovies>(_onLoadMovies);
    on<SelectBrowseGenre>(_onSelectGenre);
    add(LoadBrowseMovies());
  }

  Future<void> _onLoadMovies(
      LoadBrowseMovies event,
      Emitter<BrowseState> emit,
      ) async {
    emit(BrowseLoading());
    try {
      final movies = await _apiService.getMovies();
      _allMovies = movies;

      if (movies.isEmpty) {
        emit(BrowseEmpty());
      } else {
        final genres = _extractGenres(movies);
        emit(BrowseSuccess(
          movies: movies,
          genres: genres,
          selectedGenre: 'All',
        ));
      }
    } catch (e) {
      emit(BrowseError(e.toString()));
    }
  }

  void _onSelectGenre(
      SelectBrowseGenre event,
      Emitter<BrowseState> emit,
      ) {
    if (state is! BrowseSuccess) return;

    final currentState = state as BrowseSuccess;
    final selectedGenre = event.genre;

    List<Movie> filteredMovies;
    if (selectedGenre == 'All') {
      filteredMovies = _allMovies;
    } else {
      filteredMovies = _allMovies
          .where((movie) => movie.genres.contains(selectedGenre))
          .toList();
    }

    emit(BrowseSuccess(
      movies: filteredMovies,
      genres: currentState.genres,
      selectedGenre: selectedGenre,
    ));
  }

  List<String> _extractGenres(List<Movie> movies) {
    final genres = <String>{'All'};
    for (var movie in movies) {
      genres.addAll(movie.genres);
    }
    return genres.toList()..sort();
  }
}