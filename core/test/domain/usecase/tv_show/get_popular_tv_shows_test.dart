import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_show/tv_show.dart';
import 'package:core/domain/usecases/get_popular_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvShows usecase;
  late MockTvShowRepository mockTvShowRpository;

  setUp(() {
    mockTvShowRpository = MockTvShowRepository();
    usecase = GetPopularTvShows(mockTvShowRpository);
  });

  final tTvShows = <TvShow>[];

  group('GetPopularTvShows Tests', () {
    group('execute', () {
      test(
          'should get list of movies from the repository when execute function is called',
          () async {
        // arrange
        when(mockTvShowRpository.getPopularTvShows())
            .thenAnswer((_) async => Right(tTvShows));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tTvShows));
      });
    });
  });
}
