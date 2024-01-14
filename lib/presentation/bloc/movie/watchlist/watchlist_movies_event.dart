import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMoviesEvent extends WatchlistMoviesEvent {}

class WatchlistMoviesStatus extends WatchlistMoviesEvent {
  final int id;

  WatchlistMoviesStatus(this.id);
}

class WatchlistMoviesAdd extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  WatchlistMoviesAdd(this.movieDetail);
}

class WatchlistMoviesRemove extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  WatchlistMoviesRemove(this.movieDetail);
}
