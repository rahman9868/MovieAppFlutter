import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';

import 'watchlist_movies_event.dart';
import 'watchlist_movies_state.dart';

class WatchlistMoviesBloc extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistMoviesBloc(
      this.getWatchlistMovies,
      this.getWatchListStatus,
      this.saveWatchlist,
      this.removeWatchlist
      ) : super(WatchlistMoviesInitialState()) {

    on<FetchWatchlistMoviesEvent>((event, emit) async {
      emit(WatchlistMoviesLoadingState());

      final result = await getWatchlistMovies.execute();

      result.fold(
            (failure) {
          emit(WatchlistMoviesErrorState(failure.message));
        },
            (movies) {
          emit(WatchlistMoviesLoadedState(movies));
        },
      );
    }
    );

    on<WatchlistMoviesStatus>((event, emit) async {

      final results = await getWatchListStatus.execute(event.id);
      const isUpdate = true;
      const message = '';
      emit(WatchListMovieResponse(results, isUpdate,message));

    });

    on<WatchlistMoviesAdd>((event, emit) async {
      final movie = event.movieDetail;
      const isWatchlist = true;
      const isUpdate = true;
      final result = await saveWatchlist.execute(movie);
      result.fold((failure) {
        emit(WatchlistMoviesErrorState(failure.message));
      }, (success) {
        emit(WatchListMovieResponse(isWatchlist, isUpdate,success));
      });
    });

    on<WatchlistMoviesRemove>((event, emit) async {
      final movie = event.movieDetail;
      const isWatchlist = false;
      const isUpdate = true;
      final result = await removeWatchlist.execute(movie);
      result.fold((failure) {
        emit(WatchlistMoviesErrorState(failure.message));
      }, (success) {
        emit(WatchListMovieResponse(isWatchlist, isUpdate,success));
      });
    });

  }
}

