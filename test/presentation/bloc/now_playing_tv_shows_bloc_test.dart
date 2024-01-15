import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/now_playing_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/tv_show_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/tv_show_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_shows_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvShows])
void main() {
  late NowPlayingTvShowsBloc popularTvShowsBloc;
  late MockGetNowPlayingTvShows mockGetNowPlayingTvShows;

  setUp(() {
    mockGetNowPlayingTvShows = MockGetNowPlayingTvShows();
    popularTvShowsBloc = NowPlayingTvShowsBloc(mockGetNowPlayingTvShows);
  });

  final tTvShow = TvShow(
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

  final tTvShowList = <TvShow>[tTvShow];

  blocTest<NowPlayingTvShowsBloc, TvShowListState>(
    'emits [TvShowListLoadingState, TvShowListLoadedState] when FetchNowPlayingTvShowsEvent is added successfully',
    build: () {
      when(mockGetNowPlayingTvShows.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      return popularTvShowsBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvShowsEvent()),
    expect: () =>
        [TvShowListLoadingState(), TvShowListLoadedState(tTvShowList)],
  );

  blocTest<NowPlayingTvShowsBloc, TvShowListState>(
    'emits [TvShowListLoadingState, TvShowListErrorState] when FetchNowPlayingTvShowsEvent is added with error',
    build: () {
      when(mockGetNowPlayingTvShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvShowsBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvShowsEvent()),
    expect: () =>
        [TvShowListLoadingState(), TvShowListErrorState('Server Failure')],
  );
}
