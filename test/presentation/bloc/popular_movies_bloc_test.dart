import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/movie/list/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  blocTest<PopularMoviesBloc, MovieListState>(
    'emits [MovieListLoadingState, MovieListLoadedState] when FetchPopularMoviesEvent is added successfully',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMoviesEvent()),
    expect: () => [MovieListLoadingState(), MovieListLoadedState(tMovieList)],
  );

  blocTest<PopularMoviesBloc, MovieListState>(
    'emits [MovieListLoadingState, MovieListErrorState] when FetchPopularMoviesEvent is added with error',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMoviesEvent()),
    expect: () => [MovieListLoadingState(), MovieListErrorState('Server Failure')],
  );
}