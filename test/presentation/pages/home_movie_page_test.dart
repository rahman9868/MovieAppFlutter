import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/movie/list/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingMoviesBloc extends MockBloc<MovieListEvent, MovieListState> implements NowPlayingMoviesBloc {}
class MockPopularMoviesBloc extends MockBloc<MovieListEvent, MovieListState> implements PopularMoviesBloc {}
class MockTopRatedMoviesBloc extends MockBloc<MovieListEvent, MovieListState> implements TopRatedMoviesBloc {}

class MovieListEventFake extends Fake implements MovieListEvent {}
class MovieListStateFake extends Fake implements MovieListState {}

void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;
  
  setUpAll(() {
    registerFallbackValue(MovieListEventFake());
    registerFallbackValue(MovieListStateFake());
  });

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  testWidgets('renders Now Playing movies when loaded', (WidgetTester tester) async {
    // Arrange
    when(() => mockNowPlayingMoviesBloc.state).thenReturn(MovieListLoadedState([testMovie]));
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<NowPlayingMoviesBloc>.value(value: mockNowPlayingMoviesBloc),
          ],
          child: HomeMoviePage(),
        ),
      ),
    );

    // Wait for the Now Playing movies to load
    await tester.pump();

    // Verify that Now Playing movies are rendered
    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.byType(MovieList), findsOneWidget);
  });

  // ... Add more tests for other scenarios ...

  testWidgets('renders error message when Now Playing movies load fails', (WidgetTester tester) async {
    // Arrange
    when(() => mockNowPlayingMoviesBloc.state).thenReturn(MovieListErrorState('Error message'));
    when(() => mockPopularMoviesBloc.state).thenReturn(MovieListLoadingState());
    when(() => mockTopRatedMoviesBloc.state).thenReturn(MovieListLoadingState());

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<NowPlayingMoviesBloc>.value(value: mockNowPlayingMoviesBloc),
            BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
            BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedMoviesBloc),
          ],
          child: HomeMoviePage(),
        ),
      ),
    );

    // Wait for the Now Playing movies to load
    await tester.pump();

    // Verify that error message is rendered
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Error message'), findsOneWidget);
  });
}
