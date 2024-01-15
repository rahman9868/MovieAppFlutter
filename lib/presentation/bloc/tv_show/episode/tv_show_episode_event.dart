import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class TvShowEpisodeEvent {}

class FetchTvShowEpisodesEvent extends TvShowEpisodeEvent {
  final TvShowDetail tvShowDetail;

  FetchTvShowEpisodesEvent(this.tvShowDetail);
}

class UpdateToggleSeasonExpansion extends TvShowEpisodeEvent {
  final TvShowDetail tvShowDetail;
  final int seasonNumber;

  UpdateToggleSeasonExpansion(this.tvShowDetail, this.seasonNumber);
}
