import '../../../../domain/entities/movie_detail.dart';

abstract class MovieDetailEvent {}

class FetchMovieDetailEvent extends MovieDetailEvent {
  final int id;

  FetchMovieDetailEvent(this.id);
}
class FetchMoviesRecommendationEvent extends MovieDetailEvent {
  final int id;

  FetchMoviesRecommendationEvent(this.id);
}

class AddWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  AddWatchlistEvent(this.movie);
}

class RemoveFromWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  RemoveFromWatchlistEvent(this.movie);
}

class LoadWatchlistStatusEvent extends MovieDetailEvent {
  final int id;

  LoadWatchlistStatusEvent(this.id);
}