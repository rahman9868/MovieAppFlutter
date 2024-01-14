
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/movie/list/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  final testWatchlistMovie = Movie(
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

  blocTest<WatchlistMoviesBloc, MovieListState>(
    'emits [MovieListLoadingState, MovieListLoadedState] when FetchWatchlistMoviesEvent is added successfully',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
    expect: () => [MovieListLoadingState(), MovieListLoadedState([testWatchlistMovie])],
  );

  blocTest<WatchlistMoviesBloc, MovieListState>(
    'emits [MovieListLoadingState, MovieListErrorState] when FetchWatchlistMoviesEvent is added with error',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
    expect: () => [MovieListLoadingState(), MovieListErrorState("Can't get data")],
  );
}