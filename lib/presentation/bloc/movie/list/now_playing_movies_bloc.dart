import 'package:bloc/bloc.dart';

import '../../../../domain/usecases/get_now_playing_movies.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class NowPlayingMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc(this.getNowPlayingMovies) : super(MovieListInitialState()) {
    on<FetchNowPlayingMoviesEvent>((event, emit) async {
      emit(MovieListLoadingState());

      final result = await getNowPlayingMovies.execute();

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

