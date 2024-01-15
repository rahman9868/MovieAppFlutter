import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class TvShowDetailEvent {}

class FetchTvShowDetailEvent extends TvShowDetailEvent {
  final int id;

  FetchTvShowDetailEvent(this.id);
}
