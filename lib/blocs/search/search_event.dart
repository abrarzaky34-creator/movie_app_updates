import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchMovies extends SearchEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}