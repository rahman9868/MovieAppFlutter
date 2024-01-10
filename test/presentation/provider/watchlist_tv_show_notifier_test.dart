import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_show_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_show_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvShows])
void main() {
  late WatchlistTvShowNotifier provider;
  late MockGetWatchlistTvShows mockGetWatchlistTvShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTvShows = MockGetWatchlistTvShows();
    provider = WatchlistTvShowNotifier(
      getWatchlistTvShows: mockGetWatchlistTvShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchlistTvShows.execute())
        .thenAnswer((_) async => Right([testWatchlistTvShow]));
    // act
    await provider.fetchWatchlistTvShows();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistTvShows, [testWatchlistTvShow]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistTvShows.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistTvShows();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
