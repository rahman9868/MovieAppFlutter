import 'package:core/data/models/tv_show/tv_show_seasons_model.dart';
import 'package:core/domain/entities/tv_show/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = SeasonModel(
      airDate: "2019-05-19",
      episodeCount: 1,
      id: 1,
      name: "Season 1",
      overview: "overview",
      posterPath: "posterPath",
      seasonNumber: 1,
      voteAverage: 5.0);

  final tSeason = Season(
      airDate: "2019-05-19",
      episodeCount: 1,
      id: 1,
      name: "Season 1",
      overview: "overview",
      posterPath: "posterPath",
      seasonNumber: 1,
      voteAverage: 5.0);

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });
}
