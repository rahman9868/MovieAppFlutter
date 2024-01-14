import 'package:equatable/equatable.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMoviesEvent extends MovieListEvent {}

class FetchPopularMoviesEvent extends MovieListEvent {}

class FetchTopRatedMoviesEvent extends MovieListEvent {}
