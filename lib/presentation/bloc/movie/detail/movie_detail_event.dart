import '../../../../domain/entities/movie_detail.dart';

abstract class MovieDetailEvent {}

class FetchMovieDetailEvent extends MovieDetailEvent {
  final int id;

  FetchMovieDetailEvent(this.id);
}

