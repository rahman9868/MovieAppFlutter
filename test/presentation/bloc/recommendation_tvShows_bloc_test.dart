import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendation_tvShows_bloc_test.mocks.dart';


@GenerateMocks([GetTvShowRecommendations])
void main() {
  late TvShowRecommendationListBloc tvShowRecommendationListBloc;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;

  setUp(() {
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    tvShowRecommendationListBloc = TvShowRecommendationListBloc(mockGetTvShowRecommendations);
  });

  const tvShowId = 1;
  final tTvShow = TvShow(
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

  final tTvShowList = <TvShow>[tTvShow];

  blocTest<TvShowRecommendationListBloc, TvShowRecommendationListState>(
    'emits [TvShowRecommendationListLoadingState, TvShowRecommendationListLoadedState] when FetchTvShowRecommendationsEvent is added successfully',
    build: () {
      when(mockGetTvShowRecommendations.execute(tvShowId)).thenAnswer((_) async => Right(tTvShowList));
      return tvShowRecommendationListBloc;
    },
    act: (bloc) => bloc.add(FetchTvShowRecommendationsEvent(tvShowId)),
    expect: () => [TvShowRecommendationListLoadingState(), TvShowRecommendationListLoadedState(tTvShowList)],
  );

  blocTest<TvShowRecommendationListBloc, TvShowRecommendationListState>(
    'emits [TvShowListLoadingState, TvShowListErrorState] when FetchNowPlayingTvShowsEvent is added with error',
    build: () {
      when(mockGetTvShowRecommendations.execute(tvShowId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvShowRecommendationListBloc;
    },
    act: (bloc) => bloc.add(FetchTvShowRecommendationsEvent(tvShowId)),
    expect: () => [TvShowRecommendationListLoadingState(), TvShowRecommendationListErrorState('Server Failure')],
  );
}