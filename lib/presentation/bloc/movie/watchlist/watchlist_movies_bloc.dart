import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';

import 'watchlist_movies_event.dart';
import 'watchlist_movies_state.dart';

class WatchlistMoviesBloc extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(
      this.getWatchlistMovies
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
  }
}

