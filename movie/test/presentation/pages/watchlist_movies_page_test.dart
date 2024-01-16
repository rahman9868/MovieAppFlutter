import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movies_event.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movies_state.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';


class MockWatchlistMovieBloc extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

class WatchlistMoviesEventFake extends Fake implements WatchlistMoviesEvent {}

class WatchlistMoviesStateFake extends Fake implements WatchlistMoviesState {}

void main() {
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistMoviesEventFake());
    registerFallbackValue(WatchlistMoviesStateFake());
  });

  setUp(() {
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesBloc>.value(
      value: mockWatchlistMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Watchlist Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMoviesInitialState());
      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockWatchlistMovieBloc.state)
              .thenReturn(WatchlistMoviesLoadingState());
          await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

          final progressBarFinder = find.byType(CircularProgressIndicator);
          final centerFinder = find.byType(Center);

          expect(centerFinder, findsOneWidget);
          expect(progressBarFinder, findsOneWidget);
        });

    testWidgets('page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockWatchlistMovieBloc.state)
              .thenReturn(WatchlistMoviesLoadedState(testMovieList));

          await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

          final listViewFinder = find.byType(ListView);
          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockWatchlistMovieBloc.state)
              .thenReturn(WatchlistMoviesErrorState('Error'));

          await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

          expect(find.text('Error'), findsOneWidget);
        });
  });
}
