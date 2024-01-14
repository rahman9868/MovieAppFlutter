
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv_show/watchlist/watchlist_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/watchlist/watchlist_tv_shows_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/watchlist/watchlist_tv_shows_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tvshows_bloc_test.mocks.dart';


@GenerateMocks([
  GetWatchlistTvShows,
  GetWatchListStatusTvShow,
  SaveWatchlistTvShow,
  RemoveWatchlistTvShow,
])
void main() {
  late MockGetWatchlistTvShows mockGetWatchlistTvShows;
  late MockGetWatchListStatusTvShow mockGetWatchListStatusTvShow;
  late MockSaveWatchlistTvShow mockSaveWatchlistTvShow;
  late MockRemoveWatchlistTvShow mockRemoveWatchlistTvShow;
  late WatchlistTvShowsBloc watchlistTvShowsBloc;

  setUp(() {
    mockGetWatchlistTvShows = MockGetWatchlistTvShows();
    mockGetWatchListStatusTvShow = MockGetWatchListStatusTvShow();
    mockSaveWatchlistTvShow = MockSaveWatchlistTvShow();
    mockRemoveWatchlistTvShow = MockRemoveWatchlistTvShow();
    watchlistTvShowsBloc = WatchlistTvShowsBloc(
        mockGetWatchlistTvShows,
        mockGetWatchListStatusTvShow,
        mockSaveWatchlistTvShow,
        mockRemoveWatchlistTvShow
    );
  });

  group('WatchlistTvShowsBloc', () {
    const tvShowId = 1;
    final tvShow = TvShow(
      backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
      firstAirDate: "2023-01-23",
      genreIds: [9648, 18],
      id: 1,
      name: "Dirty Linen",
      originCountry: ["PH"],
      originalLanguage: "tl",
      originalName: "Dirty Linen",
      overview:
      "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
      popularity: 2797.914,
      posterPath: "/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg",
      voteAverage: 8.0,
      voteCount: 13,
    );

    blocTest<WatchlistTvShowsBloc, WatchlistTvShowsState>(
      'emits Loading and Loaded states when FetchNowWatchlistTvShowsEvent is added',
      build: () {
        when(mockGetWatchlistTvShows.execute()).thenAnswer((_) async => Right([tvShow]));
        return watchlistTvShowsBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvShowsEvent()),
      expect: () => [
        WatchlistTvShowsLoadingState(),
        WatchlistTvShowsLoadedState([tvShow]),
      ],
    );

    blocTest<WatchlistTvShowsBloc, WatchlistTvShowsState>(
      'emits TvShowIsWatchList state when WatchlistTvShowsStatus is added',
      build: () {
        when(mockGetWatchListStatusTvShow.execute(tvShowId)).thenAnswer((_) async => true);
        return watchlistTvShowsBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvShowsStatus(tvShow.id)),
      expect: () => [
        WatchListTvShowResponse(true, false, ''),
      ],
    );

    blocTest<WatchlistTvShowsBloc, WatchlistTvShowsState>(
      'emits WatchlistTvShowsErrorState state when WatchlistTvShowsAdd fails',
      build: () {
        when(mockSaveWatchlistTvShow.execute(testTvShowDetail)).thenAnswer((_) async => Left(ServerFailure('Error')));
        return watchlistTvShowsBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvShowsAdd(testTvShowDetail)),
      expect: () => [
        WatchlistTvShowsErrorState('Error'),
      ],
    );

    blocTest<WatchlistTvShowsBloc, WatchlistTvShowsState>(
      'emits WatchListTvShowResponse state when WatchlistTvShowsAdd is successful',
      build: () {
        when(mockSaveWatchlistTvShow.execute(testTvShowDetail)).thenAnswer((_) async => Right('Success'));
        return watchlistTvShowsBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvShowsAdd(testTvShowDetail)),
      expect: () => [
        WatchListTvShowResponse(true, true, 'Success'),
      ],
    );

    blocTest<WatchlistTvShowsBloc, WatchlistTvShowsState>(
      'emits WatchlistTvShowsErrorState state when WatchlistTvShowsRemove fails',
      build: () {
        when(mockRemoveWatchlistTvShow.execute(testTvShowDetail)).thenAnswer((_) async => Left(ServerFailure('Error')));
        return watchlistTvShowsBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvShowsRemove(testTvShowDetail)),
      expect: () => [
        WatchlistTvShowsErrorState('Error'),
      ],
    );

    blocTest<WatchlistTvShowsBloc, WatchlistTvShowsState>(
      'emits WatchListTvShowResponse state when WatchlistTvShowsRemove is successful',
      build: () {
        when(mockRemoveWatchlistTvShow.execute(testTvShowDetail)).thenAnswer((_) async => Right('Success'));
        return watchlistTvShowsBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvShowsRemove(testTvShowDetail)),
      expect: () => [
        WatchListTvShowResponse(false, true, 'Success'),
      ],
    );
  });
}