import 'package:ditonton/data/models/movie/movie_model.dart';
import 'package:ditonton/data/models/tv_show/tv_show_model.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvShowModel = TvShowModel(
    backdropPath: 'backdropPath',
    firstAirDate: "2023-01-23",
    genreIds: [1, 2, 3],
    id: 1,
    name: "Name",
    originCountry: ["ID"],
    originalLanguage: "id",
    originalName: "Original Name",
    overview: 'overview',
    popularity: 1.5,
    posterPath: 'posterPath',
    voteAverage: 1.3,
    voteCount: 1,
  );

  final tTvShow = TvShow(
    backdropPath: 'backdropPath',
    firstAirDate: "2023-01-23",
    genreIds: [1, 2, 3],
    id: 1,
    name: "Name",
    originCountry: ["ID"],
    originalLanguage: "id",
    originalName: "Original Name",
    overview: 'overview',
    popularity: 1.5,
    posterPath: 'posterPath',
    voteAverage: 1.3,
    voteCount: 1,
  );

  test('should be a subclass of TvShow entity', () async {
    final result = tTvShowModel.toEntity();
    expect(result, tTvShow);
  });
}
