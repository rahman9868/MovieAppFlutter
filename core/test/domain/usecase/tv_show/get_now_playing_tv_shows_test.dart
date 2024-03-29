import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_show/tv_show.dart';
import 'package:core/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvShows usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetNowPlayingTvShows(mockTvShowRepository);
  });

  final tTvShows = <TvShow>[];

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockTvShowRepository.getNowPlayingTvShows())
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShows));
  });
}
