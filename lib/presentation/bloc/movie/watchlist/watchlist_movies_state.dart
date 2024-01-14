
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/movie.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesInitialState extends WatchlistMoviesState {}

class WatchlistMoviesLoadingState extends WatchlistMoviesState {}

class WatchlistMoviesLoadedState extends WatchlistMoviesState {
  final List<Movie> movies;

  WatchlistMoviesLoadedState(this.movies);

  @override
  List<Object> get props => [movies];
}

class WatchlistMoviesErrorState extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class MovieIsWatchList extends WatchlistMoviesState {
  final bool isWatchlist;

  MovieIsWatchList(this.isWatchlist);

  @override
  List<Object> get props => [isWatchlist];
}

class WatchListMovieResponse extends WatchlistMoviesState {
  final bool isWatchlist;
  final bool isUpdate;
  final String message;

  WatchListMovieResponse(this.isWatchlist, this.isUpdate,this.message);

  @override
  List<Object> get props => [message];
}