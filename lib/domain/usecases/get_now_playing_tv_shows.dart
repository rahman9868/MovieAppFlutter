import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

import '../entities/tv_show/tv_show.dart';
import '../repositories/tv_show_repository.dart';

class GetNowPlayingTvShows {
  final TvShowRepository repository;

  GetNowPlayingTvShows(this.repository);

  Future<Either<Failure, List<TvShow>>> execute() {
    return repository.getNowPlayingTvShows();
  }
}
