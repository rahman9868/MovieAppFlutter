import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movies_event.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/movie_detail_notifier_test.mocks.dart';
import '../provider/watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchlistMoviesBloc watchlistMoviesBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistMoviesBloc = WatchlistMoviesBloc(
        mockGetWatchlistMovies,
        mockGetWatchListStatus,
        mockSaveWatchlist,
        mockRemoveWatchlist
    );
  });

  group('WatchlistMoviesBloc', () {
    const movieId = 1;
    final movie = Movie(
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

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'emits Loading and Loaded states when FetchNowWatchlistMoviesEvent is added',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Right([movie]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
      expect: () => [
        WatchlistMoviesLoadingState(),
        WatchlistMoviesLoadedState([movie]),
      ],
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'emits MovieIsWatchList state when WatchlistMoviesStatus is added',
      build: () {
        when(mockGetWatchListStatus.execute(movieId)).thenAnswer((_) async => true);
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMoviesStatus(movie.id)),
      expect: () => [
        WatchListMovieResponse(true, false, ''),
      ],
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'emits WatchlistMoviesErrorState state when WatchlistMoviesAdd fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(ServerFailure('Error')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMoviesAdd(testMovieDetail)),
      expect: () => [
        WatchlistMoviesErrorState('Error'),
      ],
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'emits WatchListMovieResponse state when WatchlistMoviesAdd is successful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Success'));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMoviesAdd(testMovieDetail)),
      expect: () => [
        WatchListMovieResponse(true, true, 'Success'),
      ],
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'emits WatchlistMoviesErrorState state when WatchlistMoviesRemove fails',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(ServerFailure('Error')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMoviesRemove(testMovieDetail)),
      expect: () => [
        WatchlistMoviesErrorState('Error'),
      ],
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'emits WatchListMovieResponse state when WatchlistMoviesRemove is successful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Success'));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMoviesRemove(testMovieDetail)),
      expect: () => [
        WatchListMovieResponse(false, true, 'Success'),
      ],
    );
  });
}