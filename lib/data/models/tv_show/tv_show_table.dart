
import 'package:ditonton/data/models/movie/movie_table.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show_detail.dart';
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

  factory TvShowTable.fromEntity(TvShowDetail movie) => TvShowTable(
    id: movie.id,
    name: movie.name,
    posterPath: movie.posterPath,
    overview: movie.overview,
    voteAverage: movie.voteAverage,
    isMovie: 0
  );

  factory TvShowTable.fromMap(Map<String, dynamic> map) => TvShowTable(
    id: map['id'],
    name: map['name'],
    posterPath: map['posterPath'],
    overview: map['overview'],
    voteAverage: map['voteAverage'],
    isMovie: 0
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'posterPath': posterPath,
    'overview': overview,
    'voteAverage': voteAverage,
    'isMovie': isMovie,
  };

  TvShow toEntity() => TvShow.watchlist(
    id: id,
    overview: overview,
    posterPath: posterPath,
    name: name,
    voteAverage: voteAverage,
  );

  MovieTable toMovieTable() => MovieTable(
        id: id,
        title: name,
        posterPath: posterPath,
        overview: overview,
        voteAverage: voteAverage,
        isMovie: isMovie
    );

  @override
  List<Object?> get props => [id, name, posterPath, overview, isMovie];
}