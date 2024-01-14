import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/movie.dart';
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


  MovieDetail? _movieDetail = null;
  List<Movie> _moviesRecommendation = [];
  bool _watchListStatus = false;

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
      _watchListStatus = await getWatchListStatus.execute(event.id);

      result.fold(
            (failure) {
          emit(MovieDetailErrorState(failure.message));
        },
            (movie) {
              _movieDetail = movie;
              recommendations.fold(
                      (failure) {
                    emit(MovieDetailErrorState(failure.message));
                  },
              (movies) {
                        _moviesRecommendation = movies;
                emit(MovieDetailLoadedState(movie, movies, _watchListStatus, false, false, ''));
                }
              );
        },
      );
    });
    on<AddWatchlistEvent>((event, emit) async {

      final results = await saveWatchlist.execute(event.movie);

      results.fold(
            (failure) {
              emit(MovieDetailLoadedState(_movieDetail!, _moviesRecommendation, _watchListStatus, true, false, failure.message));
        },
            (message) {
              _watchListStatus = true;
              emit(MovieDetailLoadedState(_movieDetail!, _moviesRecommendation, _watchListStatus, true, true, message));
        },
      );
    });
    on<RemoveFromWatchlistEvent>((event, emit) async {

      final results = await removeWatchlist.execute(event.movie);

      results.fold(
            (failure) {
              emit(MovieDetailLoadedState(_movieDetail!, _moviesRecommendation, _watchListStatus, true, false, failure.message));
        },
            (message) {
              _watchListStatus = false;
          emit(MovieDetailLoadedState(_movieDetail!, _moviesRecommendation, _watchListStatus, true, true, message));
        },
      );
    });

  }

}