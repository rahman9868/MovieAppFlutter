import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist_tv_show.dart';
import 'package:tv_show/presentation/bloc/watchlist_status/watchlist_tv_show_status_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchListStatusTvShow extends Mock implements GetWatchListStatusTvShow {}

class MockSaveWatchlistTvShow extends Mock implements SaveWatchlistTvShow {}

class MockRemoveWatchlistTvShow extends Mock implements RemoveWatchlistTvShow {}

void main() {
  late MockGetWatchListStatusTvShow mockGetWatchListStatusTvShow;
  late MockSaveWatchlistTvShow mockSaveWatchlistTvShow;
  late MockRemoveWatchlistTvShow mockRemoveWatchlistTvShow;
  late WatchlistStatusTvShowCubit watchlistStatusTvShowCubit;

  setUp(() {
    mockGetWatchListStatusTvShow = MockGetWatchListStatusTvShow();
    mockSaveWatchlistTvShow = MockSaveWatchlistTvShow();
    mockRemoveWatchlistTvShow = MockRemoveWatchlistTvShow();
    watchlistStatusTvShowCubit = WatchlistStatusTvShowCubit(
      getWatchlistTvShowStatus: mockGetWatchListStatusTvShow,
      saveWatchlistTvShow: mockSaveWatchlistTvShow,
      removeWatchlistTvShow: mockRemoveWatchlistTvShow
    );
  });

  const tId = 1;

  group('TvShow Bloc, Get Watchlist Status TvShow:', () {
    blocTest<WatchlistStatusTvShowCubit, WatchlistStatusTvShowState>(
      'should get watchlist true',
      build: () {
        when(() => mockGetWatchListStatusTvShow.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistStatusTvShowCubit;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        const WatchlistStatusTvShowState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('TvShow Bloc, Save Watchlist TvShow:', () {
    blocTest<WatchlistStatusTvShowCubit, WatchlistStatusTvShowState>(
      'should execute save watchlist when function called',
      build: () {
        when(() => mockSaveWatchlistTvShow.execute(testTvShowDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(() => mockGetWatchListStatusTvShow.execute(testTvShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTvShowCubit;
      },
      act: (bloc) => bloc.addWatchlistTvShow(testTvShowDetail),
      expect: () => [
        const WatchlistStatusTvShowState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistStatusTvShowCubit, WatchlistStatusTvShowState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(() => mockSaveWatchlistTvShow.execute(testTvShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTvShow.execute(testTvShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTvShowCubit;
      },
      act: (bloc) => bloc.addWatchlistTvShow(testTvShowDetail),
      expect: () => [
        const WatchlistStatusTvShowState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('TvShow Bloc, Remove Watchlist TvShow:', () {
    blocTest<WatchlistStatusTvShowCubit, WatchlistStatusTvShowState>(
      'should execute remove watchlist when function called',
      build: () {
        when(() => mockRemoveWatchlistTvShow.execute(testTvShowDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(() => mockGetWatchListStatusTvShow.execute(testTvShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTvShowCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTvShow(testTvShowDetail),
      expect: () => [
        const WatchlistStatusTvShowState(
            isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistStatusTvShowCubit, WatchlistStatusTvShowState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(() => mockRemoveWatchlistTvShow.execute(testTvShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTvShow.execute(testTvShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTvShowCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTvShow(testTvShowDetail),
      expect: () => [
        const WatchlistStatusTvShowState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}
