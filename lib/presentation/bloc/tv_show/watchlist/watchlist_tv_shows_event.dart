import 'package:equatable/equatable.dart';

abstract class WatchlistTvShowsEvent extends Equatable {
  const WatchlistTvShowsEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvShowsEvent extends WatchlistTvShowsEvent {}
