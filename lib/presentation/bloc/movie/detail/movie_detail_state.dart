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

class MovieDetailLoadedState extends MovieDetailState {
  final MovieDetail movie;

  MovieDetailLoadedState(this.movie);
}

class MovieDetailErrorState extends MovieDetailState {
  final String message;

  MovieDetailErrorState(this.message);
}
