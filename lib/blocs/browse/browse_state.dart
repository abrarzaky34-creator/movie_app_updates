import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class BrowseState extends Equatable {
  const BrowseState();

  @override
  List<Object?> get props => [];
}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {}

class BrowseSuccess extends BrowseState {
  final List<Movie> movies;
  final List<String> genres;
  final String selectedGenre;

  const BrowseSuccess({
    required this.movies,
    required this.genres,
    required this.selectedGenre,
  });

  @override
  List<Object?> get props => [
    movies,
    genres,
    selectedGenre,
  ];
}

class BrowseEmpty extends BrowseState {}

class BrowseError extends BrowseState {
  final String message;

  const BrowseError(this.message);

  @override
  List<Object?> get props => [message];
}