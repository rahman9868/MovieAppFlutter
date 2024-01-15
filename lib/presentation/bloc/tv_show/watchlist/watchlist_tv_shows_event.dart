import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class WatchlistTvShowsEvent extends Equatable {
  const WatchlistTvShowsEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvShowsEvent extends WatchlistTvShowsEvent {}
