import 'package:equatable/equatable.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_detail.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitialState extends MovieDetailState {}

class MovieDetailLoadingState extends MovieDetailState {}

class UpdateWatchlistLoadingState extends MovieDetailState {}

class MovieDetailLoadedState extends MovieDetailState {
  final MovieDetail movie;

  MovieDetailLoadedState(this.movie);
}

class MovieRecommendationsLoadedState extends MovieDetailState {
  final List<Movie> movieRecommendations;
  MovieRecommendationsLoadedState(this.movieRecommendations);
}

class MovieDetailErrorState extends MovieDetailState {
  final String message;

  MovieDetailErrorState(this.message);
}

class WatchlistStatusLoadedState extends MovieDetailState {
  final bool isAddedToWatchlist;

  WatchlistStatusLoadedState(this.isAddedToWatchlist);
}

class UpdateWatchlistSuccessState extends MovieDetailState {
  final String message;

  UpdateWatchlistSuccessState(this.message);
}

class UpdateWatchlistErrorState extends MovieDetailState {
  final String message;

  UpdateWatchlistErrorState(this.message);
}