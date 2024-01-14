import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';

import '../../../../domain/usecases/get_watchlist_tv_show.dart';
import 'watchlist_tv_shows_event.dart';
import 'watchlist_tv_shows_state.dart';

class WatchlistTvShowsBloc extends Bloc<WatchlistTvShowsEvent, WatchlistTvShowsState> {
  final GetWatchlistTvShows getWatchlistTvShows;
  final GetWatchListStatusTvShow getWatchListStatusTvShow;
  final SaveWatchlistTvShow saveWatchlistTvShow;
  final RemoveWatchlistTvShow removeWatchlistTvShow;

  WatchlistTvShowsBloc(
      this.getWatchlistTvShows,
      this.getWatchListStatusTvShow,
      this.saveWatchlistTvShow,
      this.removeWatchlistTvShow
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

    on<WatchlistTvShowsStatus>((event, emit) async {

      final results = await getWatchListStatusTvShow.execute(event.id);
      const isUpdate = true;
      const message = '';
      emit(WatchListTvShowResponse(results, isUpdate,message));

    });

    on<WatchlistTvShowsAdd>((event, emit) async {
      final tvShow = event.tvShowDetail;
      const isWatchlist = true;
      const isUpdate = true;
      final result = await saveWatchlistTvShow.execute(tvShow);
      result.fold((failure) {
        emit(WatchlistTvShowsErrorState(failure.message));
      }, (success) {
        emit(WatchListTvShowResponse(isWatchlist, isUpdate,success));
      });
    });

    on<WatchlistTvShowsRemove>((event, emit) async {
      final tvShow = event.tvShowDetail;
      const isWatchlist = false;
      const isUpdate = true;
      final result = await removeWatchlistTvShow.execute(tvShow);
      result.fold((failure) {
        emit(WatchlistTvShowsErrorState(failure.message));
      }, (success) {
        emit(WatchListTvShowResponse(isWatchlist, isUpdate,success));
      });
    });

  }
}

