
abstract class MovieDetailEvent {}

class FetchMovieDetailEvent extends MovieDetailEvent {
  final int id;

  FetchMovieDetailEvent(this.id);
}

