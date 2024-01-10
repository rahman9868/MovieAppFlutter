import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/tv_show/tv_show.dart';
import '../../domain/usecases/get_now_playing_tv_shows.dart';

class NowPlayingTvShowsNotifier extends ChangeNotifier {
  final GetNowPlayingTvShows getNowPlayingTvShows;

  NowPlayingTvShowsNotifier({required this.getNowPlayingTvShows});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<TvShow> _tvShow = [];

  List<TvShow> get tvShow => _tvShow;

  String _message = '';

  String get message => _message;

  Future<void> fetchNowPlayingTvShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvShows.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvShowsData) {
        _tvShow = tvShowsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
