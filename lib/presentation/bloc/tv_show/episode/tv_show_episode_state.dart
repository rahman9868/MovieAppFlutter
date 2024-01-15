import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/episode.dart';
import '../../../../domain/entities/tv_show/tv_show.dart';
import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class TvShowEpisodeState extends Equatable {
  const TvShowEpisodeState();

  @override
  List<Object> get props => [];
}

class TvShowEpisodeInitialState extends TvShowEpisodeState {}

class TvShowEpisodesLoadingState extends TvShowEpisodeState {}

class EpisodesTvShowSuccessState extends TvShowEpisodeState {
  final Map<int, List<Episode>> episodeMap;
  final TvShowDetail tvShowDetail;
  final Map<int, bool> isExpandedMap;

  EpisodesTvShowSuccessState(this.episodeMap, this.tvShowDetail, this.isExpandedMap);
}

class EpisodesTvShowErrorState extends TvShowEpisodeState {
  final String message;

  EpisodesTvShowErrorState(this.message);
}