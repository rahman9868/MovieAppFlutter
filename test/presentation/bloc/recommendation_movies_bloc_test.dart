import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_state.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movies_recommendations_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendation_movies_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationListBloc movieRecommendationListBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationListBloc =
        MovieRecommendationListBloc(mockGetMovieRecommendations);
  });

  const movieId = 1;
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

  blocTest<MovieRecommendationListBloc, MovieRecommendationListState>(
    'emits [MovieRecommendationListLoadingState, MovieRecommendationListLoadedState] when FetchMovieRecommendationsEvent is added successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(movieId))
          .thenAnswer((_) async => Right(tMovieList));
      return movieRecommendationListBloc;
    },
    act: (bloc) => bloc.add(FetchMovieRecommendationsEvent(movieId)),
    expect: () => [
      MovieRecommendationListLoadingState(),
      MovieRecommendationListLoadedState(tMovieList)
    ],
  );

  blocTest<MovieRecommendationListBloc, MovieRecommendationListState>(
    'emits [MovieListLoadingState, MovieListErrorState] when FetchNowPlayingMoviesEvent is added with error',
    build: () {
      when(mockGetMovieRecommendations.execute(movieId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationListBloc;
    },
    act: (bloc) => bloc.add(FetchMovieRecommendationsEvent(movieId)),
    expect: () => [
      MovieRecommendationListLoadingState(),
      MovieRecommendationListErrorState('Server Failure')
    ],
  );
}
