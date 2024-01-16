import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_show/presentation/bloc/watchlist/watchlist_tv_shows_bloc.dart';
import 'package:tv_show/presentation/bloc/watchlist/watchlist_tv_shows_event.dart';
import 'package:tv_show/presentation/bloc/watchlist/watchlist_tv_shows_state.dart';
import 'package:tv_show/presentation/pages/watchlist_tv_shows_page.dart';

import '../../dummy_data/dummy_objects.dart';


class MockWatchlistTvShowBloc extends MockBloc<WatchlistTvShowsEvent, WatchlistTvShowsState>
    implements WatchlistTvShowsBloc {}

class WatchlistTvShowsEventFake extends Fake implements WatchlistTvShowsEvent {}

class WatchlistTvShowsStateFake extends Fake implements WatchlistTvShowsState {}

void main() {
  late MockWatchlistTvShowBloc mockWatchlistTvShowBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistTvShowsEventFake());
    registerFallbackValue(WatchlistTvShowsStateFake());
  });

  setUp(() {
    mockWatchlistTvShowBloc = MockWatchlistTvShowBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvShowsBloc>.value(
      value: mockWatchlistTvShowBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TvShow Page, Watchlist TvShow Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockWatchlistTvShowBloc.state)
          .thenReturn(WatchlistTvShowsInitialState());
      await tester.pumpWidget(makeTestableWidget(WatchlistTvShowsPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockWatchlistTvShowBloc.state)
              .thenReturn(WatchlistTvShowsLoadingState());
          await tester.pumpWidget(makeTestableWidget(WatchlistTvShowsPage()));

          final progressBarFinder = find.byType(CircularProgressIndicator);
          final centerFinder = find.byType(Center);

          expect(centerFinder, findsOneWidget);
          expect(progressBarFinder, findsOneWidget);
        });

    testWidgets('page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockWatchlistTvShowBloc.state)
              .thenReturn(WatchlistTvShowsLoadedState(testTvShowList));

          await tester.pumpWidget(makeTestableWidget(WatchlistTvShowsPage()));

          final listViewFinder = find.byType(ListView);
          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockWatchlistTvShowBloc.state)
              .thenReturn(WatchlistTvShowsErrorState('Error'));

          await tester.pumpWidget(makeTestableWidget(WatchlistTvShowsPage()));

          expect(find.text('Error'), findsOneWidget);
        });
  });
}
