import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/episode.dart';
import '../../../../domain/entities/tv_show/tv_show.dart';
import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class TvShowDetailState extends Equatable {
  const TvShowDetailState();

  @override
  List<Object> get props => [];
}

class TvShowDetailInitialState extends TvShowDetailState {}

class TvShowDetailLoadingState extends TvShowDetailState {}

class TvShowEpisodesLoadingState extends TvShowDetailState {}

class UpdateWatchlistLoadingState extends TvShowDetailState {}

class TvShowDetailLoadedState extends TvShowDetailState {
  final TvShowDetail tvShow;
  final Map<int, List<Episode>> episodeMap;

  TvShowDetailLoadedState(
      this.tvShow,
      this.episodeMap);
}

class TvShowRecommendationsLoadedState extends TvShowDetailState {
  final List<TvShow> movieRecommendations;
  TvShowRecommendationsLoadedState(this.movieRecommendations);
}

class TvShowDetailErrorState extends TvShowDetailState {
  final String message;

  TvShowDetailErrorState(this.message);
}

class WatchlistStatusLoadedState extends TvShowDetailState {
  final bool isAddedToWatchlist;

  WatchlistStatusLoadedState(this.isAddedToWatchlist);
}

class EpisodesTvShowSuccessState extends TvShowDetailState {
  final Map<int, List<Episode>> episodeMap;
  final TvShowDetail tvShowDetail;
  final Map<int, bool> isExpandedMap;

  EpisodesTvShowSuccessState(this.episodeMap, this.tvShowDetail, this.isExpandedMap);
}

class EpisodesTvShowErrorState extends TvShowDetailState {
  final String message;

  EpisodesTvShowErrorState(this.message);
}

class UpdateWatchlistSuccessState extends TvShowDetailState {
  final String message;

  UpdateWatchlistSuccessState(this.message);
}

class UpdateWatchlistErrorState extends TvShowDetailState {
  final String message;

  UpdateWatchlistErrorState(this.message);
}