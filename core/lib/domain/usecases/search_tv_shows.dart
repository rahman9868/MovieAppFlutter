import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';

import '../entities/tv_show/tv_show.dart';
import '../repositories/tv_show_repository.dart';

class SearchTvShows {
  final TvShowRepository repository;

  SearchTvShows(this.repository);

  Future<Either<Failure, List<TvShow>>> execute(String query) {
    return repository.searchTvShows(query);
  }
}
