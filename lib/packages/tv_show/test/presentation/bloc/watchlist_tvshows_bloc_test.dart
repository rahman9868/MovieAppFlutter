import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_show/tv_show.dart';
import 'package:core/domain/usecases/get_watchlist_tv_show.dart';
import 'package:tv_show/presentation/bloc/watchlist/watchlist_tv_shows_bloc.dart';
import 'package:tv_show/presentation/bloc/watchlist/watchlist_tv_shows_event.dart';
import 'package:tv_show/presentation/bloc/watchlist/watchlist_tv_shows_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tvshows_bloc_test.mocks.dart';


@GenerateMocks([GetWatchlistTvShows])
void main() {
  late MockGetWatchlistTvShows mockGetWatchlistTvShows;
  late WatchlistTvShowsBloc watchlistTvShowsBloc;

  setUp(() {
    mockGetWatchlistTvShows = MockGetWatchlistTvShows();
    watchlistTvShowsBloc = WatchlistTvShowsBloc(mockGetWatchlistTvShows);
  });

  group('WatchlistTvShowsBloc', () {
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
        when(mockGetWatchlistTvShows.execute())
            .thenAnswer((_) async => Right([tvShow]));
        return watchlistTvShowsBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvShowsEvent()),
      expect: () => [
        WatchlistTvShowsLoadingState(),
        WatchlistTvShowsLoadedState([tvShow]),
      ],
    );
  });
}
