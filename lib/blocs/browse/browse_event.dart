import 'package:equatable/equatable.dart';

abstract class BrowseEvent extends Equatable {
  const BrowseEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrowseMovies extends BrowseEvent {
  const LoadBrowseMovies();
}

class SelectBrowseGenre extends BrowseEvent {
  final String genre;

  const SelectBrowseGenre(this.genre);

  @override
  List<Object?> get props => [genre];
}