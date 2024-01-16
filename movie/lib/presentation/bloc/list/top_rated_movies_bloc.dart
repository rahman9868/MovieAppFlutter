import 'package:bloc/bloc.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';

import 'movie_list_event.dart';
import 'movie_list_state.dart';

class TopRatedMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies) : super(MovieListInitialState()) {
    on<FetchTopRatedMoviesEvent>((event, emit) async {
      emit(MovieListLoadingState());

      final result = await getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(MovieListErrorState(failure.message));
        },
        (movies) {
          emit(MovieListLoadedState(movies));
        },
      );
    });
  }
}
