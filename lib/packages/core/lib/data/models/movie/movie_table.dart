import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv_show/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_show/tv_show.dart';

class MovieTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final double? voteAverage;
  final int isMovie;

  MovieTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.isMovie,
  });

  factory MovieTable.fromEntity(MovieDetail movie) => MovieTable(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      voteAverage: movie.voteAverage,
      isMovie: 1);

  factory MovieTable.fromTvShow(TvShowDetail tvShow) => MovieTable(
      id: tvShow.id,
      title: tvShow.name,
      posterPath: tvShow.posterPath,
      overview: tvShow.overview,
      voteAverage: tvShow.voteAverage,
      isMovie: 0);

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
      voteAverage: map['voteAverage'],
      isMovie: 1);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'voteAverage': voteAverage,
        'isMovie': isMovie,
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        title: title,
      );

  TvShow toTvShowEntity() => TvShow.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        name: title,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview];
}
