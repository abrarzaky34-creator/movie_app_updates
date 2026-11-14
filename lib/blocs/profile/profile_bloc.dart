import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/app_user.dart';
import '../../models/movie.dart';
import '../../services/firestore_service.dart';
import '../../services/yts_api_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirestoreService _firestoreService;
  final YtsApiService _apiService;

  ProfileBloc({
    FirestoreService? firestoreService,
    YtsApiService? apiService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _apiService = apiService ?? YtsApiService(),
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<FavoritesChanged>(_onFavoritesChanged);
    on<HistoryChanged>(_onHistoryChanged);
  }

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    try {
      final userMap = await _firestoreService.getUserProfile(event.uid);

      if (userMap == null) {
        emit(const ProfileError('User profile not found'));
        return;
      }

      final user = AppUser.fromMap(event.uid, userMap);

      final watchlist = await _getMovies(user.favorites);

      final history = await _getMovies(user.watchedMovies);

      emit(ProfileLoaded(
        profile: user,
        watchlist: watchlist,
        history: history,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onFavoritesChanged(
      FavoritesChanged event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is! ProfileLoaded) return;

    final currentState = state as ProfileLoaded;
    emit(currentState.copyWith(watchlistLoading: true));

    try {
      final watchlist = await _getMovies(event.movieIds);
      emit(currentState.copyWith(
        watchlist: watchlist,
        watchlistLoading: false,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onHistoryChanged(
      HistoryChanged event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is! ProfileLoaded) return;

    final currentState = state as ProfileLoaded;
    emit(currentState.copyWith(historyLoading: true));

    try {
      final history = await _getMovies(event.movieIds);
      emit(currentState.copyWith(
        history: history,
        historyLoading: false,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<List<Movie>> _getMovies(List<int> ids) async {
    final List<Movie> movies = [];
    for (final id in ids) {
      try {
        final movie = await _apiService.getMovieById(id);
        if (movie != null) {
          movies.add(movie);
        }
      } catch (_) {

      }
    }
    return movies;
  }
}