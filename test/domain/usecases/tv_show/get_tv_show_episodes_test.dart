import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_show/episode.dart';
import 'package:ditonton/domain/usecases/get_tv_show_episodes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvShowEpisodes usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvShowEpisodes(mockTvShowRepository);
  });

  final tId = 1;
  final sNumber = 2;
  final tEpisodesTvShows = <Episode>[];

  test('should get list of Episode TV Show from the repository', () async {
    // arrange
    when(mockTvShowRepository.getTvShowEpisodes(tId, sNumber))
        .thenAnswer((_) async => Right(tEpisodesTvShows));
    // act
    final result = await usecase.execute(tId, sNumber);
    // assert
    expect(result, Right(tEpisodesTvShows));
  });
}
