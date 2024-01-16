import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';


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
}
