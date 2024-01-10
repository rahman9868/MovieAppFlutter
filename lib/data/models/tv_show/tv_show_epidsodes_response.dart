import 'package:ditonton/data/models/tv_show/tv_show_episode_model.dart';
import 'package:equatable/equatable.dart';

class TvShowEpisodesResponse extends Equatable {
  final List<Episode> episodeList;

  TvShowEpisodesResponse({required this.episodeList});

  factory TvShowEpisodesResponse.fromJson(Map<String, dynamic> json) =>
      TvShowEpisodesResponse(
        episodeList: List<Episode>.from((json["episodes"] as List)
            .map((x) => Episode.fromJson(x))
            .where((element) => element.episodeNumber != null)),
      );

  @override
  List<Object> get props => [episodeList];
}
