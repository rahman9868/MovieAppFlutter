import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_status/watchlist_movie_status_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchListStatusMovie extends Mock implements GetWatchListStatus {}

class MockSaveWatchlistMovie extends Mock implements SaveWatchlist {}

class MockRemoveWatchlistMovie extends Mock implements RemoveWatchlist {}

void main() {
  late MockGetWatchListStatusMovie mockGetWatchListStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;
  late WatchlistStatusMovieCubit watchlistStatusMovieCubit;

  setUp(() {
    mockGetWatchListStatusMovie = MockGetWatchListStatusMovie();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    watchlistStatusMovieCubit = WatchlistStatusMovieCubit(
      getWatchListStatus: mockGetWatchListStatusMovie,
      saveWatchlist: mockSaveWatchlistMovie,
      removeWatchlist: mockRemoveWatchlistMovie
    );
  });

  const tId = 1;

  group('Movie Bloc, Get Watchlist Status Movie:', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should get watchlist true',
      build: () {
        when(() => mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        const WatchlistStatusMovieState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('Movie Bloc, Save Watchlist Movie:', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should execute save watchlist when function called',
      build: () {
        when(() => mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(() => mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(() => mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('Movie Bloc, Remove Watchlist Movie:', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should execute remove watchlist when function called',
      build: () {
        when(() => mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(() => mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(() => mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}
