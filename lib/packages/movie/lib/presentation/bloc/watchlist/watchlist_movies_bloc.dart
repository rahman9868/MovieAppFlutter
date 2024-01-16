import 'package:bloc/bloc.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';

import 'watchlist_movies_event.dart';
import 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(this.getWatchlistMovies)
      : super(WatchlistMoviesInitialState()) {
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
    });
  }
}
