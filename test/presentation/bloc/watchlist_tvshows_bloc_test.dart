
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/tv_show_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/tv_show_list_state.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/watchlist_tvShows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tvshows_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvShows])
void main() {
  late WatchlistTvShowsBloc watchlistTvShowsBloc;
  late MockGetWatchlistTvShows mockGetWatchlistTvShows;

  setUp(() {
    mockGetWatchlistTvShows = MockGetWatchlistTvShows();
    watchlistTvShowsBloc = WatchlistTvShowsBloc(mockGetWatchlistTvShows);
  });

  final testWatchlistTvShow = TvShow(
    backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
    firstAirDate: "2023-01-23",
    genreIds: [9648, 18],
    id: 11,
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

  blocTest<WatchlistTvShowsBloc, TvShowListState>(
    'emits [TvShowListLoadingState, TvShowListLoadedState] when FetchWatchlistTvShowsEvent is added successfully',
    build: () {
      when(mockGetWatchlistTvShows.execute()).thenAnswer((_) async => Right([testWatchlistTvShow]));
      return watchlistTvShowsBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvShowsEvent()),
    expect: () => [TvShowListLoadingState(), TvShowListLoadedState([testWatchlistTvShow])],
  );

  blocTest<WatchlistTvShowsBloc, TvShowListState>(
    'emits [TvShowListLoadingState, TvShowListErrorState] when FetchWatchlistTvShowsEvent is added with error',
    build: () {
      when(mockGetWatchlistTvShows.execute()).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistTvShowsBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvShowsEvent()),
    expect: () => [TvShowListLoadingState(), TvShowListErrorState("Can't get data")],
  );
}