import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/list/movie_list_event.dart';
import 'package:movie/presentation/bloc/list/movie_list_state.dart';
import 'package:movie/presentation/bloc/list/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc popularMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    popularMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
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

  blocTest<TopRatedMoviesBloc, MovieListState>(
    'emits [MovieListLoadingState, MovieListLoadedState] when FetchTopRatedMoviesEvent is added successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMoviesEvent()),
    expect: () => [MovieListLoadingState(), MovieListLoadedState(tMovieList)],
  );

  blocTest<TopRatedMoviesBloc, MovieListState>(
    'emits [MovieListLoadingState, MovieListErrorState] when FetchTopRatedMoviesEvent is added with error',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMoviesEvent()),
    expect: () =>
        [MovieListLoadingState(), MovieListErrorState('Server Failure')],
  );
}
