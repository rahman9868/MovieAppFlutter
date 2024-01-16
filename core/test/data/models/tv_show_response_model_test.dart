import 'dart:convert';

import 'package:core/data/models/tv_show/tv_show_model.dart';
import 'package:core/data/models/tv_show/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvShowModel = TvShowModel(
    backdropPath: "/path.jpg",
    firstAirDate: "2023-01-23",
    genreIds: [1, 2],
    id: 1,
    name: "Name",
    originCountry: ["ID"],
    originalLanguage: "id",
    originalName: "Original Name",
    overview: 'Overview',
    popularity: 75.2,
    posterPath: "/path.jpg",
    voteAverage: 5.0,
    voteCount: 13,
  );
  final tTvShowResponseModel =
      TvShowResponse(tvShowList: <TvShowModel>[tTvShowModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_show/now_playing.json'));
      // act
      final result = TvShowResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvShowResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvShowResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2023-01-23",
            "genre_ids": [1, 2],
            "id": 1,
            "name": "Name",
            "origin_country": ["ID"],
            "original_language": "id",
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 75.2,
            "poster_path": "/path.jpg",
            "vote_average": 5.0,
            "vote_count": 13
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
