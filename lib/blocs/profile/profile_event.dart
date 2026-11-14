import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String uid;

  const LoadProfile(this.uid);

  @override
  List<Object?> get props => [uid];
}

class FavoritesChanged extends ProfileEvent {
  final List<int> movieIds;

  const FavoritesChanged(this.movieIds);

  @override
  List<Object?> get props => [movieIds];
}

class HistoryChanged extends ProfileEvent {
  final List<int> movieIds;

  const HistoryChanged(this.movieIds);

  @override
  List<Object?> get props => [movieIds];
}