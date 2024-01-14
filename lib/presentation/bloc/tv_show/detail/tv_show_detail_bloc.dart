import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_show/episode.dart';
import '../../../../domain/entities/tv_show/tv_show.dart';
import '../../../../domain/entities/tv_show/tv_show_detail.dart';
import '../../../../domain/usecases/get_tv_show_detail.dart';
import '../../../../domain/usecases/get_tv_show_episodes.dart';
import '../../../../domain/usecases/get_tv_show_recommendations.dart';
import '../../../../domain/usecases/get_watchlist_tv_show_status.dart';
import 'tv_show_detail_event.dart';
import 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail getTvShowDetail;
  final GetTvShowEpisodes getTvShowEpisodes;
  final GetWatchListStatusTvShow getWatchListStatusTvShow;
  final GetTvShowRecommendations getTvShowRecommendations;
  final SaveWatchlistTvShow saveWatchlistTvShow;
  final RemoveWatchlistTvShow removeWatchlistTvShow;

  TvShowDetail? _tvShow = null;
  Map<int, List<Episode>> _episodesMap = {};
  String _episodeFailedMessage = '';
  List<TvShow> _tvShowsRecommendation = [];
  bool _watchListStatus = false;

  TvShowDetailBloc(
      this.getTvShowDetail,
      this.getTvShowEpisodes,
      this.getWatchListStatusTvShow,
      this.getTvShowRecommendations,
      this.saveWatchlistTvShow,
      this.removeWatchlistTvShow
      ) : super(TvShowDetailInitialState()) {
    on<FetchTvShowDetailEvent>((event, emit) async {
      emit(
          TvShowDetailLoadingState());

      final result = await getTvShowDetail.execute(event.id);
      final recommendations = await getTvShowRecommendations.execute(event.id);
      _watchListStatus = await getWatchListStatusTvShow.execute(event.id);

      result.fold(
            (failure) {
          emit(TvShowDetailErrorState(failure.message));
        },
            (tvShow) {
              _tvShow = tvShow;
              recommendations.fold(
                      (failure) {
                    emit(TvShowDetailErrorState(failure.message));
                  },
              (tvShows) async {
                _tvShowsRecommendation = tvShows;
                emit(TvShowDetailLoadedState(tvShow, tvShows, _watchListStatus, _episodesMap, false, false, ''));
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
                  emit(TvShowDetailLoadedState(tvShow, tvShows, _watchListStatus, _episodesMap, false, false, ''));
                }else {
                  emit(EpisodesTvShowErrorState(_episodeFailedMessage));
                }
                }
              );
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
    on<AddWatchlistEvent>((event, emit) async {

      final results = await saveWatchlistTvShow.execute(event.tvShow);

      results.fold(
            (failure) {
              emit(TvShowDetailLoadedState(_tvShow!, _tvShowsRecommendation, _watchListStatus, _episodesMap, true, false, failure.message));

            },
            (message) {
              _watchListStatus = true;
              emit(TvShowDetailLoadedState(_tvShow!, _tvShowsRecommendation, _watchListStatus, _episodesMap, true, true, message));
        },
      );
    });
    on<RemoveFromWatchlistEvent>((event, emit) async {

      final results = await removeWatchlistTvShow.execute(event.tvShow);

      results.fold(
            (failure) {
              emit(TvShowDetailLoadedState(_tvShow!, _tvShowsRecommendation, _watchListStatus, _episodesMap, true, false, failure.message));
        },
            (message) {
              _watchListStatus = false;
              emit(TvShowDetailLoadedState(_tvShow!, _tvShowsRecommendation, _watchListStatus, _episodesMap, true, true, message));
        },
      );
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