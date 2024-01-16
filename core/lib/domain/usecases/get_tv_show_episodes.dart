import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show/episode.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';

class GetTvShowEpisodes {
  final TvShowRepository repository;

  GetTvShowEpisodes(this.repository);

  Future<Either<Failure, List<Episode>>> execute(int id, int seasonNumber) {
    return repository.getTvShowEpisodes(id, seasonNumber);
  }
}
