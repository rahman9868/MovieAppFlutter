import 'package:bloc_test/bloc_test.dart';
import 'package:movie/presentation/bloc/list/movie_list_event.dart';
import 'package:movie/presentation/bloc/list/movie_list_state.dart';
import 'package:movie/presentation/bloc/list/popular_movies_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';


class MockPopularMovieBloc extends MockBloc<MovieListEvent, MovieListState>
    implements PopularMoviesBloc {}

class PopularMoviesEventFake extends Fake implements MovieListEvent {}

class PopularMoviesStateFake extends Fake implements MovieListState {}

void main() {
  late MockPopularMovieBloc mockPopularMovieBloc;

  setUpAll(() {
    registerFallbackValue(PopularMoviesEventFake());
    registerFallbackValue(PopularMoviesStateFake());
  });

  setUp(() {
    mockPopularMovieBloc = MockPopularMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockPopularMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Popular Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(MovieListInitialState());
      await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(MovieListLoadingState());
      await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(MovieListLoadedState(testMovieList));

      await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(MovieListErrorState('Error'));

      await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

      expect(find.text('Error'), findsOneWidget);
    });
  });
}
