import 'dart:convert';

import 'package:core/common/exception.dart';
import 'package:core/data/datasources/tv_show_remote_data_source.dart';
import 'package:core/data/models/tv_show/tv_show_detail_model.dart';
import 'package:core/data/models/tv_show/tv_show_epidsodes_response.dart';
import 'package:core/data/models/tv_show/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvShowRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvShowRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TvShows', () {
    final tTvShowList = TvShowResponse.fromJson(
            json.decode(readJson('dummy_data/tv_show/now_playing.json')))
        .tvShowList;

    test('should return list of TvShow Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show/now_playing.json'), 200));
      // act
      final result = await dataSource.getNowPlayingTvShows();
      // assert
      expect(result, equals(tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TvShows', () {
    final tTvShowList = TvShowResponse.fromJson(
            json.decode(readJson('dummy_data/tv_show/popular.json')))
        .tvShowList;

    test('should return list of tvShows when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_show/popular.json'), 200));
      // act
      final result = await dataSource.getPopularTvShows();
      // assert
      expect(result, tTvShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TvShows', () {
    final tTvShowList = TvShowResponse.fromJson(
            json.decode(readJson('dummy_data/tv_show/top_rated.json')))
        .tvShowList;

    test('should return list of tvShows when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show/top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTvShows();
      // assert
      expect(result, tTvShowList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tvShow detail', () {
    final tId = 1;
    final tTvShowDetail = TvShowDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_show/tv_show_detail.json')));

    test('should return tvShow detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show/tv_show_detail.json'), 200));
      // act
      final result = await dataSource.getTvShowDetail(tId);
      // assert
      expect(result, equals(tTvShowDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tvShow recommendations', () {
    final tTvShowList = TvShowResponse.fromJson(json.decode(
            readJson('dummy_data/tv_show/tv_show_recommendations.json')))
        .tvShowList;
    final tId = 1;

    test('should return list of TvShow Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show/tv_show_recommendations.json'),
              200));
      // act
      final result = await dataSource.getTvShowRecommendations(tId);
      // assert
      expect(result, equals(tTvShowList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tvShows', () {
    final tSearchResult = TvShowResponse.fromJson(json
            .decode(readJson('dummy_data/tv_show/search_vikings_tv_show.json')))
        .tvShowList;
    final tQuery = 'Vikings';

    test('should return list of tvShows when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show/search_vikings_tv_show.json'), 200));
      // act
      final result = await dataSource.searchTvShows(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvShows(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tvShow episodes', () {
    final tTvShowEpisodeList = TvShowEpisodesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_show/tv_show_episodes.json')))
        .episodeList;
    final tId = 1;
    final tSeason = 2;

    test('should return list of Episode Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/season/$tSeason?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show/tv_show_episodes.json'), 200));
      // act
      final result = await dataSource.getEpisodes(tId, tSeason);
      // assert
      expect(result, equals(tTvShowEpisodeList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/season/$tSeason?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getEpisodes(tId, tSeason);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
