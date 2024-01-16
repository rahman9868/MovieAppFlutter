import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(MovieDetailInitialState()) {
    on<FetchMovieDetailEvent>((event, emit) async {
      emit(MovieDetailLoadingState());

      final result = await getMovieDetail.execute(event.id);

      result.fold(
        (failure) {
          emit(MovieDetailErrorState(failure.message));
        },
        (movie) {
          emit(MovieDetailLoadedState(movie));
        },
      );
    });
  }
}
