import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

import '../entities/tv_show/tv_show.dart';
import '../repositories/tv_show_repository.dart';

class GetWatchlistTvShows {
  final TvShowRepository _repository;

  GetWatchlistTvShows(this._repository);

  Future<Either<Failure, List<TvShow>>> execute() {
    return _repository.getWatchlistTvShows();
  }
}
