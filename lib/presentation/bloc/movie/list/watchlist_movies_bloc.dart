import 'package:bloc/bloc.dart';
import '../../../../domain/usecases/get_watchlist_movies.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class WatchlistMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(this.getWatchlistMovies) : super(MovieListInitialState()) {
    on<FetchWatchlistMoviesEvent>((event, emit) async {
      emit(MovieListLoadingState());

      final result = await getWatchlistMovies.execute();

      result.fold(
            (failure) {
          emit(MovieListErrorState(failure.message));
        },
            (movies) {
          emit(MovieListLoadedState(movies));
        },
      );
    }
    );
  }
}

