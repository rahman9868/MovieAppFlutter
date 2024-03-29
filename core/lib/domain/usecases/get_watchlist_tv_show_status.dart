import 'package:core/domain/repositories/tv_show_repository.dart';

class GetWatchListStatusTvShow {
  final TvShowRepository repository;

  GetWatchListStatusTvShow(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
