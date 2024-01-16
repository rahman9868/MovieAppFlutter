import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';


abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListInitialState extends MovieListState {}

class MovieListLoadingState extends MovieListState {}

class MovieListLoadedState extends MovieListState {
  final List<Movie> movies;

  MovieListLoadedState(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieListErrorState extends MovieListState {
  final String message;

  MovieListErrorState(this.message);

  @override
  List<Object> get props => [message];
}
