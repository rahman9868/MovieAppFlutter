import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
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
])
void main() {
  late TvShowDetailBloc tvShowDetailBloc;
  late MockGetTvShowDetail mockGetTvShowDetail;

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();

    tvShowDetailBloc = TvShowDetailBloc(
      mockGetTvShowDetail
    );
  });

  group('TvShowDetailBloc', () {
    const tvShowId = 1;
    final tvShowDetail = testTvShowDetail;

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
          TvShowDetailLoadedState(tvShowDetail),
        ];
      },
    );

    
    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'emits Loading and Error states when FetchTvShowDetailEvent fails',
      build: () {
        when(mockGetTvShowDetail.execute(tvShowId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowDetailEvent(tvShowId)),
      expect: () => [
        TvShowDetailLoadingState(),
        TvShowDetailErrorState('Server Failure'),
      ],
      verify: (bloc) => TvShowDetailLoadingState(),
    );
  });
}
