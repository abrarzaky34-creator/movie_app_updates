import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/yts_api_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final YtsApiService _apiService;

  SearchBloc({YtsApiService? apiService})
      : _apiService = apiService ?? YtsApiService(),
        super(SearchInitial()) {
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onSearchMovies(
      SearchMovies event,
      Emitter<SearchState> emit,
      ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final movies = await _apiService.searchMovies(query);

      if (movies.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchSuccess(movies));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}