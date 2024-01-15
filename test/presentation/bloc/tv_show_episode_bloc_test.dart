

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_show_episodes.dart';
import 'package:ditonton/presentation/bloc/tv_show/episode/tv_show_episode_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/episode/tv_show_episode_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/episode/tv_show_episode_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_episode_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvShowEpisodes,
])
void main() {
  late MockGetTvShowEpisodes mockGetTvShowEpisodes;
  late TvShowEpisodeBloc tvShowEpisodeBloc;

  setUp(() {
    mockGetTvShowEpisodes = MockGetTvShowEpisodes();
    tvShowEpisodeBloc = TvShowEpisodeBloc(mockGetTvShowEpisodes);
  });

  const sNumber = 1;
  const tMovieId = 1;

  group('TvShowEpisodeBloc', () {

    blocTest<TvShowEpisodeBloc, TvShowEpisodeState>(
      'emits [TvShowEpisodesLoadingState, EpisodesTvShowSuccessState] when FetchTvShowEpisodesEvent is added',
      build: () {
        when(() => mockGetTvShowEpisodes.execute(tMovieId, sNumber))
            .thenAnswer((_) async => Right(testEpisodesList));
        return tvShowEpisodeBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowEpisodesEvent(testTvShowDetail)),
      expect: () {
        when(() => mockGetTvShowEpisodes.execute(tMovieId, sNumber))
            .thenAnswer((_) async => Right(testEpisodesList));

        return [
          TvShowEpisodesLoadingState(),
          EpisodesTvShowSuccessState(
            testEpisodesMap,
            testTvShowDetail,
            testIsExpandedMap,
          ),
        ];
      },
    );

    blocTest<TvShowEpisodeBloc, TvShowEpisodeState>(
      'emits [TvShowEpisodesLoadingState, EpisodesTvShowSuccessState] when UpdateToggleSeasonExpansion is added',
      build: () {
        return tvShowEpisodeBloc;
      },
      act: (bloc) async {
        bloc.add(UpdateToggleSeasonExpansion(
          testTvShowDetail,
          1,
        ));

        await Future.delayed(Duration(milliseconds: 1000));
        await bloc.close();
      },
      expect: () => [
        EpisodesTvShowSuccessState(
          testEpisodesMap,
          testTvShowDetail,
          testIsExpandedMap,
        ),
      ],
    );
  });
}