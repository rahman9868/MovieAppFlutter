import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/get_movie_detail.dart';
import '../../../../domain/usecases/get_movie_recommendations.dart';
import '../../../../domain/usecases/get_watchlist_status.dart';
import '../../../../domain/usecases/remove_watchlist.dart';
import '../../../../domain/usecases/save_watchlist.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetWatchListStatus getWatchListStatus;
  final GetMovieRecommendations getMovieRecommendations;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc(
      this.getMovieDetail,
      this.getWatchListStatus,
      this.getMovieRecommendations,
      this.saveWatchlist,
      this.removeWatchlist
      ) : super(MovieDetailInitialState()) {
    on<FetchMovieDetailEvent>((event, emit) async {
      emit(MovieDetailLoadingState());

      final result = await getMovieDetail.execute(event.id);
      final recommendations = await getMovieRecommendations.execute(event.id);
      final watchListStatus = await getWatchListStatus.execute(event.id);

      result.fold(
            (failure) {
          emit(MovieDetailErrorState(failure.message));
        },
            (movie) {
              recommendations.fold(
                      (failure) {
                    emit(MovieDetailErrorState(failure.message));
                  },
              (movies) {
                emit(MovieDetailLoadedState(movie, movies, watchListStatus));
                }
              );
        },
      );
    });
    on<AddWatchlistEvent>((event, emit) async {

      final results = await saveWatchlist.execute(event.movie);

      results.fold(
            (failure) {
          emit(UpdateWatchlistErrorState(failure.message));
        },
            (message) {
          emit(UpdateWatchlistSuccessState(message));
        },
      );
    });
    on<RemoveFromWatchlistEvent>((event, emit) async {

      final results = await removeWatchlist.execute(event.movie);

      results.fold(
            (failure) {
          emit(UpdateWatchlistErrorState(failure.message));
        },
            (message) {
          emit(UpdateWatchlistSuccessState(message));
        },
      );
    });

  }

}