import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_show_episodes.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/tv_show/episode.dart';
import '../../domain/entities/tv_show/tv_show.dart';
import '../../domain/entities/tv_show/tv_show_detail.dart';
import '../../domain/usecases/get_tv_show_detail.dart';
import '../../domain/usecases/get_tv_show_recommendations.dart';

class TvShowDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvShowDetail getTvShowDetail;
  final GetTvShowEpisodes getTvShowEpisodes;
  final GetTvShowRecommendations getTvShowRecommendations;
  final GetWatchListStatusTvShow getWatchListStatus;
  final SaveWatchlistTvShow saveWatchlist;
  final RemoveWatchlistTvShow removeWatchlist;

  TvShowDetailNotifier({
    required this.getTvShowDetail,
    required this.getTvShowEpisodes,
    required this.getTvShowRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late TvShowDetail _tvShow;

  TvShowDetail get tvShow => _tvShow;

  RequestState _tvShowState = RequestState.Empty;

  RequestState get tvShowState => _tvShowState;

  List<TvShow> _tvShowRecommendations = [];

  List<TvShow> get tvShowRecommendations => _tvShowRecommendations;

  RequestState _recommendationState = RequestState.Empty;

  RequestState get recommendationState => _recommendationState;

  String _message = '';

  String get message => _message;

  bool _isAddedtoWatchlist = false;

  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  RequestState _episodeState = RequestState.Empty;

  RequestState get episodeState => _episodeState;

  Map<int, List<Episode>> _episodesMap = {};

  Map<int, List<Episode>> get episodesMap => _episodesMap;

  Future<void> fetchTvShowDetail(int id) async {
    _tvShowState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvShowDetail.execute(id);
    final recommendationResult = await getTvShowRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShow) {
        _recommendationState = RequestState.Loading;
        _tvShow = tvShow;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvShows) {
            _recommendationState = RequestState.Loaded;
            _tvShowRecommendations = tvShows;
          },
        );
        _tvShowState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchEpisodes(int tvShowId) async {
    try {
      _episodeState = RequestState.Loading;
      notifyListeners();

      for (int seasonNumber
          in tvShow.seasons.map((season) => season.seasonNumber)) {
        if (_episodesMap[seasonNumber]?.isNotEmpty == true) continue;

        final episodesResult =
            await getTvShowEpisodes.execute(tvShowId, seasonNumber);
        episodesResult.fold(
          (failure) {
            _episodeState = RequestState.Error;
            _message = failure.message;
          },
          (episodes) {
            _episodesMap[seasonNumber] = episodes;
          },
        );
      }

      _episodeState = RequestState.Loaded;
      notifyListeners();
    } catch (e) {
      _episodeState = RequestState.Error;
    }
    notifyListeners();
  }

  String _watchlistMessage = '';

  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvShowDetail tvShow) async {
    final result = await saveWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> removeFromWatchlist(TvShowDetail tvShow) async {
    final result = await removeWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }


  Map<int, bool> isExpandedMap = {};

  void initializeIsExpandedMap() {
      isExpandedMap = Map.fromIterable(tvShow.seasons,
          key: (season) => season.seasonNumber,
          value: (_) => false);
    }

  void toggleSeasonExpansion(int seasonNumber) {
    isExpandedMap[seasonNumber] = !isExpandedMap[seasonNumber]!;
    notifyListeners();
  }
}
