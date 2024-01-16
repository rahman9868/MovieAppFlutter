import 'package:core/data/models/movie/movie_table.dart';
import 'package:core/domain/entities/tv_show/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;
  final double? voteAverage;
  final int isMovie;

  TvShowTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.isMovie,
  });

  factory TvShowTable.fromEntity(TvShowDetail tvShow) => TvShowTable(
      id: tvShow.id,
      name: tvShow.name,
      posterPath: tvShow.posterPath,
      overview: tvShow.overview,
      voteAverage: tvShow.voteAverage,
      isMovie: 0);

  MovieTable toMovieTable() => MovieTable(
      id: id,
      title: name,
      posterPath: posterPath,
      overview: overview,
      voteAverage: voteAverage,
      isMovie: isMovie);

  @override
  List<Object?> get props => [id, name, posterPath, overview, isMovie];
}
