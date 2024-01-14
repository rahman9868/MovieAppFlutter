import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class WatchlistTvShowsEvent extends Equatable {
  const WatchlistTvShowsEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvShowsEvent extends WatchlistTvShowsEvent {}

class WatchlistTvShowsStatus extends WatchlistTvShowsEvent {
  final int id;

  WatchlistTvShowsStatus(this.id);
}

class WatchlistTvShowsAdd extends WatchlistTvShowsEvent {
  final TvShowDetail tvShowDetail;

  WatchlistTvShowsAdd(this.tvShowDetail);
}

class WatchlistTvShowsRemove extends WatchlistTvShowsEvent {
  final TvShowDetail tvShowDetail;

  WatchlistTvShowsRemove(this.tvShowDetail);
}
