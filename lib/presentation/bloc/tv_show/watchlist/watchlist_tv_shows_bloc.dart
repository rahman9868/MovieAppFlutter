import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';

import '../../../../domain/usecases/get_watchlist_tv_show.dart';
import 'watchlist_tv_shows_event.dart';
import 'watchlist_tv_shows_state.dart';

class WatchlistTvShowsBloc extends Bloc<WatchlistTvShowsEvent, WatchlistTvShowsState> {
  final GetWatchlistTvShows getWatchlistTvShows;

  WatchlistTvShowsBloc(
      this.getWatchlistTvShows
      ) : super(WatchlistTvShowsInitialState()) {

    on<FetchWatchlistTvShowsEvent>((event, emit) async {
      emit(WatchlistTvShowsLoadingState());

      final result = await getWatchlistTvShows.execute();

      result.fold(
            (failure) {
          emit(WatchlistTvShowsErrorState(failure.message));
        },
            (tvShows) {
          emit(WatchlistTvShowsLoadedState(tvShows));
        },
      );
    }
    );

  }
}

