import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class TvShowDetailEvent {}

class FetchTvShowDetailEvent extends TvShowDetailEvent {
  final int id;

  FetchTvShowDetailEvent(this.id);
}
class FetchTvShowsRecommendationEvent extends TvShowDetailEvent {
  final int id;

  FetchTvShowsRecommendationEvent(this.id);
}
class FetchTvShowEpisodesEvent extends TvShowDetailEvent {
  final TvShowDetail tvShow;

  FetchTvShowEpisodesEvent(this.tvShow);
}
class UpdateToggleSeasonExpansion extends TvShowDetailEvent {
  final TvShowDetail tvShowDetail;
  final int seasonNumber;

  UpdateToggleSeasonExpansion(this.tvShowDetail,this.seasonNumber);
}

class AddWatchlistEvent extends TvShowDetailEvent {
  final TvShowDetail tvShow;

  AddWatchlistEvent(this.tvShow);
}

class RemoveFromWatchlistEvent extends TvShowDetailEvent {
  final TvShowDetail tvShow;

  RemoveFromWatchlistEvent(this.tvShow);
}

class LoadWatchlistStatusEvent extends TvShowDetailEvent {
  final int id;

  LoadWatchlistStatusEvent(this.id);
}