import 'package:ditonton/data/models/tv_show/tv_show_episode_model.dart';
import 'package:ditonton/domain/entities/tv_show/episode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tEpisodeModel = EpisodeModel(
      airDate: "2023-01-10",
      episodeNumber: 2,
      id: 1,
      name: "Episode 1",
      overview: "Overview",
      productionCode: "ProductionCode",
      runtime: 10,
      seasonNumber: 1,
      showId: 10,
      stillPath: "StillPath",
      voteAverage: 7.2,
      voteCount: 5
  );

  final tEpisode = Episode(
      airDate: "2023-01-10",
      episodeNumber: 2,
      id: 1,
      name: "Episode 1",
      overview: "Overview",
      productionCode: "ProductionCode",
      runtime: 10,
      seasonNumber: 1,
      showId: 10,
      stillPath: "StillPath",
      voteAverage: 7.2,
      voteCount: 5
  );

  test('should be a subclass of Episode entity', () async {
    final result = tEpisodeModel.toEntity();
    expect(result, tEpisode);
  });
}