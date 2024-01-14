import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_show/episode.dart';
import '../../../../domain/entities/tv_show/tv_show_detail.dart';
import '../../../../domain/usecases/get_tv_show_detail.dart';
import '../../../../domain/usecases/get_tv_show_episodes.dart';
import 'tv_show_detail_event.dart';
import 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail getTvShowDetail;
  final GetTvShowEpisodes getTvShowEpisodes;

  TvShowDetail? _tvShow = null;
  Map<int, List<Episode>> _episodesMap = {};
  String _episodeFailedMessage = '';

  TvShowDetailBloc(
      this.getTvShowDetail,
      this.getTvShowEpisodes,
      ) : super(TvShowDetailInitialState()) {
    on<FetchTvShowDetailEvent>((event, emit) async {
      emit(
          TvShowDetailLoadingState());

      final result = await getTvShowDetail.execute(event.id);

      result.fold(
            (failure) {
          emit(TvShowDetailErrorState(failure.message));
        },
            (tvShow) async {
              emit(TvShowDetailLoadedState(tvShow, _episodesMap));
              for (int seasonNumber
              in tvShow.seasons.map((season) => season.seasonNumber)) {
                if (_episodesMap[seasonNumber]?.isNotEmpty == true) continue;

                final episodesResult =
                    await getTvShowEpisodes.execute(event.id, seasonNumber);
                episodesResult.fold(
                      (failure) {
                    _episodeFailedMessage = failure.message;
                  },
                      (episodes) {
                    _episodesMap[seasonNumber] = episodes;
                  },
                );
              }
              if(_episodesMap.isNotEmpty){
                emit(TvShowDetailLoadedState(tvShow, _episodesMap));
              }else {
                emit(EpisodesTvShowErrorState(_episodeFailedMessage));
              }
        },
      );
    });
    on<FetchTvShowEpisodesEvent>((event, emit) async {
      emit(
          TvShowEpisodesLoadingState());

      if(_tvShow != null){
        for (int seasonNumber
        in _tvShow!.seasons.map((season) => season.seasonNumber)) {
          if (_episodesMap[seasonNumber]?.isNotEmpty == true) continue;

          final episodesResult =
          await getTvShowEpisodes.execute(event.id, seasonNumber);
          episodesResult.fold(
                (failure) {
                  _episodeFailedMessage = failure.message;
            },
                (episodes) {
              _episodesMap[seasonNumber] = episodes;
            },
          );
        }
        if(_episodesMap.isNotEmpty){
          emit(EpisodesTvShowSuccessState(_episodesMap, _tvShow!));
        }else {
          emit(EpisodesTvShowErrorState(_episodeFailedMessage));
        }
      } else {
        emit(EpisodesTvShowErrorState('Failed'));
      }
    });

  }

  Map<int, bool> isExpandedMap = {};

  void initializeIsExpandedMap() {
    if (_tvShow != null) {
      isExpandedMap = Map.fromIterable(
        _tvShow!.seasons,
        key: (season) => season.seasonNumber,
        value: (_) => false,
      );
    }
  }

  void toggleSeasonExpansion(int seasonNumber) {
    if (_tvShow != null) {
      isExpandedMap[seasonNumber] = !isExpandedMap[seasonNumber]!;
    }
  }


}