import 'package:equatable/equatable.dart';

abstract class TvShowListEvent extends Equatable {
  const TvShowListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvShowsEvent extends TvShowListEvent {}

class FetchPopularTvShowsEvent extends TvShowListEvent {}

class FetchTopRatedTvShowsEvent extends TvShowListEvent {}

class FetchWatchlistTvShowsEvent extends TvShowListEvent {}
