import 'package:equatable/equatable.dart';

import '../../models/app_user.dart';
import '../../models/movie.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final AppUser? profile;
  final List<Movie> watchlist;
  final List<Movie> history;
  final bool watchlistLoading;
  final bool historyLoading;

  const ProfileLoaded({
    required this.profile,
    required this.watchlist,
    required this.history,
    this.watchlistLoading = false,
    this.historyLoading = false,
  });

  ProfileLoaded copyWith({
    AppUser? profile,
    List<Movie>? watchlist,
    List<Movie>? history,
    bool? watchlistLoading,
    bool? historyLoading,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      watchlist: watchlist ?? this.watchlist,
      history: history ?? this.history,
      watchlistLoading:
      watchlistLoading ?? this.watchlistLoading,
      historyLoading:
      historyLoading ?? this.historyLoading,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    watchlist,
    history,
    watchlistLoading,
    historyLoading,
  ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}