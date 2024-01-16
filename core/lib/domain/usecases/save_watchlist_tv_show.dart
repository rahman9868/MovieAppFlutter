import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show/tv_show_detail.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';

class SaveWatchlistTvShow {
  final TvShowRepository repository;

  SaveWatchlistTvShow(this.repository);

  Future<Either<Failure, String>> execute(TvShowDetail tvShowDetail) {
    return repository.saveWatchlist(tvShowDetail);
  }
}
