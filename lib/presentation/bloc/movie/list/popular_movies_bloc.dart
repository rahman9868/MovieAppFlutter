import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';

import 'movie_list_event.dart';
import 'movie_list_state.dart';

class PopularMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(MovieListInitialState()) {
    on<FetchPopularMoviesEvent>((event, emit) async {
      emit(MovieListLoadingState());

      final result = await getPopularMovies.execute();

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
