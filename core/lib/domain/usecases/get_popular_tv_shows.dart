import 'package:core/domain/entities/tv_show/tv_show.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';

class GetPopularTvShows {
  final TvShowRepository repository;

  GetPopularTvShows(this.repository);

  Future<Either<Failure, List<TvShow>>> execute() {
    return repository.getPopularTvShows();
  }
}
