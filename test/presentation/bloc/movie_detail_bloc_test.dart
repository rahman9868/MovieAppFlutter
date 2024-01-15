import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  group('MovieDetailBloc', () {
    const movieId = 1;
    final movieDetail = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 120,
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits Loading and Loaded states when FetchMovieDetailEvent is added',
      build: () {
        when(mockGetMovieDetail.execute(movieId))
            .thenAnswer((_) async => Right(movieDetail));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetailEvent(movieId)),
      expect: () => [
        MovieDetailLoadingState(),
        MovieDetailLoadedState(movieDetail),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(movieId));
        return FetchMovieDetailEvent(movieId).id;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits Loading and Error states when FetchMovieDetailEvent fails',
      build: () {
        when(mockGetMovieDetail.execute(movieId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetailEvent(movieId)),
      expect: () => [
        MovieDetailLoadingState(),
        MovieDetailErrorState('Server Failure'),
      ],
      verify: (bloc) => MovieDetailLoadingState(),
    );
  });
}
