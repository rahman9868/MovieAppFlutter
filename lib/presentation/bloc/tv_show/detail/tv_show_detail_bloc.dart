import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_show/episode.dart';
import '../../../../domain/usecases/get_tv_show_detail.dart';
import '../../../../domain/usecases/get_tv_show_episodes.dart';
import 'tv_show_detail_event.dart';
import 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail getTvShowDetail;
  final GetTvShowEpisodes getTvShowEpisodes;

  Map<int, List<Episode>> _episodesMap = {};
  String _episodeFailedMessage = '';
  Map<int, bool> _isExpandedMap = {};

  TvShowDetailBloc(
    this.getTvShowDetail,
    this.getTvShowEpisodes,
  ) : super(TvShowDetailInitialState()) {
    on<FetchTvShowDetailEvent>((event, emit) async {
      emit(TvShowDetailLoadingState());

      final result = await getTvShowDetail.execute(event.id);

      result.fold(
        (failure) {
          emit(TvShowDetailErrorState(failure.message));
        },
        (tvShow) {
          emit(TvShowDetailLoadedState(tvShow, _episodesMap));
        },
      );
    });
    on<FetchTvShowEpisodesEvent>((event, emit) async {
      emit(TvShowEpisodesLoadingState());

      for (int seasonNumber
          in event.tvShow.seasons.map((season) => season.seasonNumber)) {
        if (_episodesMap[seasonNumber]?.isNotEmpty == true) continue;

        _isExpandedMap[seasonNumber] = false;
        final episodesResult =
            await getTvShowEpisodes.execute(event.tvShow.id, seasonNumber);
        episodesResult.fold(
          (failure) {
            _episodeFailedMessage = failure.message;
          },
          (episodes) {
            _episodesMap[seasonNumber] = episodes;
          },
        );
      }
      if (_episodesMap.isNotEmpty) {
        emit(EpisodesTvShowSuccessState(
            _episodesMap, event.tvShow, _isExpandedMap));
      } else {
        emit(EpisodesTvShowErrorState(_episodeFailedMessage));
      }
    });
    on<UpdateToggleSeasonExpansion>((event, emit) async {
      emit(TvShowEpisodesLoadingState());
      _isExpandedMap[event.seasonNumber] = !_isExpandedMap[event.seasonNumber]!;
      emit(EpisodesTvShowSuccessState(
          _episodesMap, event.tvShowDetail, _isExpandedMap));
    });
  }
}
