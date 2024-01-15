import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/tv_show.dart';

abstract class WatchlistTvShowsState extends Equatable {
  const WatchlistTvShowsState();

  @override
  List<Object> get props => [];
}

class WatchlistTvShowsInitialState extends WatchlistTvShowsState {}

class WatchlistTvShowsLoadingState extends WatchlistTvShowsState {}

class WatchlistTvShowsLoadedState extends WatchlistTvShowsState {
  final List<TvShow> tvShows;

  WatchlistTvShowsLoadedState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class WatchlistTvShowsErrorState extends WatchlistTvShowsState {
  final String message;

  WatchlistTvShowsErrorState(this.message);
}
