
abstract class TvShowDetailEvent {}

class FetchTvShowDetailEvent extends TvShowDetailEvent {
  final int id;

  FetchTvShowDetailEvent(this.id);
}
