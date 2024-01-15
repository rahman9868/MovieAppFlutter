import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_show/episode.dart';
import '../../../../domain/usecases/get_tv_show_episodes.dart';
import 'tv_show_episode_event.dart';
import 'tv_show_episode_state.dart';

class TvShowEpisodeBloc extends Bloc<TvShowEpisodeEvent, TvShowEpisodeState> {
  final GetTvShowEpisodes getTvShowEpisodes;

  Map<int, List<Episode>> _episodesMap = {};
  String _episodeFailedMessage = '';
  Map<int, bool> _isExpandedMap = {};

  TvShowEpisodeBloc(
    this.getTvShowEpisodes,
  ) : super(TvShowEpisodeInitialState()) {
    on<FetchTvShowEpisodesEvent>((event, emit) async {
      print("FetchTvShowEpisodesEvent ${event.tvShowDetail}");
      emit(TvShowEpisodesLoadingState());

      for (int seasonNumber
          in event.tvShowDetail.seasons.map((season) => season.seasonNumber)) {
        if (_episodesMap[seasonNumber]?.isNotEmpty == true) continue;

        print("FetchTvShowEpisodesEvent seasonNumber $seasonNumber}");
        _isExpandedMap[seasonNumber] = false;
        final episodesResult = await getTvShowEpisodes.execute(
            event.tvShowDetail.id, seasonNumber);
        episodesResult.fold(
          (failure) {
            _episodeFailedMessage = failure.message;
          },
          (episodes) {
            _episodesMap[seasonNumber] = episodes;
          },
        );
      }
      print(
          "FetchTvShowEpisodesEvent Finish Looping ${_episodesMap.isNotEmpty}");
      if (_episodesMap.isNotEmpty) {
        emit(EpisodesTvShowSuccessState(
            _episodesMap, event.tvShowDetail, _isExpandedMap));
      } else {
        print(
            "FetchTvShowEpisodesEvent EpisodesTvShowErrorState $_episodeFailedMessage}");
        emit(EpisodesTvShowErrorState(_episodeFailedMessage));
      }
    });
    on<UpdateToggleSeasonExpansion>((event, emit) async {
      _isExpandedMap[event.seasonNumber] = !_isExpandedMap[event.seasonNumber]!;
      emit(EpisodesTvShowSuccessState(
          _episodesMap, event.tvShowDetail, _isExpandedMap));
    });
  }
}
