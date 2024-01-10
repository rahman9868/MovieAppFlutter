import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_show/tv_show_episode_model.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';

class GetTvShowEpisodes {
  final TvShowRepository repository;

  GetTvShowEpisodes(this.repository);

  Future<Either<Failure, List<Episode>>> execute(int id, int seasonNumber) {
    return repository.getTvShowEpisodes(id, seasonNumber);
  }
}
