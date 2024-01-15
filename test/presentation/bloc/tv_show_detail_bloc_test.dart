
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_show/episode.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_episodes.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvShowDetail,
  GetTvShowEpisodes,
])
void main() {
  late TvShowDetailBloc tvShowDetailBloc;
  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowEpisodes mockGetTvShowEpisodes;

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowEpisodes = MockGetTvShowEpisodes();

    tvShowDetailBloc = TvShowDetailBloc(
      mockGetTvShowDetail,
      mockGetTvShowEpisodes,
    );
  });

  group('TvShowDetailBloc', () {
    const tvShowId = 1;
    final tvShowDetail = testTvShowDetail;

    final episodesMap = {
      1: testEpisodesList,
    };

    const sNumber = 1;

    final isExpandedMap = {
      1: true,
      2: false,
    };

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'emits TvShowDetailLoadingState and TvShowDetailLoadedState',
      build: () {
        when(mockGetTvShowDetail.execute(tvShowId))
            .thenAnswer((_) async => Right(tvShowDetail));
        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowDetailEvent(tvShowId)),
      expect: () {

        when(mockGetTvShowDetail.execute(tvShowId))
            .thenAnswer((_) async => Right(tvShowDetail));

        return [
          TvShowDetailLoadingState(),
          TvShowDetailLoadedState(tvShowDetail, episodesMap),
        ];
      },
    );

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'emits TvShowEpisodesLoadingState and EpisodesTvShowSuccessState',
      build: () {
        when(mockGetTvShowEpisodes.execute(tvShowId,sNumber))
            .thenAnswer((_) async => Right(episodesMap[sNumber]!));
        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowEpisodesEvent(tvShowDetail)),
      expect: () {
        when(mockGetTvShowEpisodes.execute(tvShowId, sNumber))
            .thenAnswer((_) async => Right(episodesMap[sNumber]!));

        return [
          TvShowEpisodesLoadingState(),
          EpisodesTvShowSuccessState(episodesMap, testTvShowDetail, isExpandedMap),
        ];
      },
    );

  });
}
