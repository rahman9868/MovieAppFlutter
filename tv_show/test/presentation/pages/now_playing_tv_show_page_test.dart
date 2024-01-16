import 'package:bloc_test/bloc_test.dart';
import 'package:tv_show/presentation/bloc/list/now_playing_tv_shows_bloc.dart';
import 'package:tv_show/presentation/bloc/list/tv_show_list_event.dart';
import 'package:tv_show/presentation/bloc/list/tv_show_list_state.dart';
import 'package:tv_show/presentation/pages/now_playing_tv_shows_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTvShowBloc
    extends MockBloc<TvShowListEvent, TvShowListState>
    implements NowPlayingTvShowsBloc {}

class NowPlayingTvShowsEventFake extends Fake implements TvShowListEvent {}

class NowPlayingTvShowsStateFake extends Fake implements TvShowListState {}

void main() {
  late MockNowPlayingTvShowBloc mockNowPlayingTvShowBloc;

  setUpAll(() {
    registerFallbackValue(NowPlayingTvShowsEventFake());
    registerFallbackValue(NowPlayingTvShowsStateFake());
  });

  setUp(() {
    mockNowPlayingTvShowBloc = MockNowPlayingTvShowBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvShowsBloc>.value(
      value: mockNowPlayingTvShowBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TvShow Page, NowPlaying TvShow Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockNowPlayingTvShowBloc.state)
          .thenReturn(TvShowListInitialState());
      await tester.pumpWidget(makeTestableWidget(NowPlayingTvShowsPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvShowBloc.state)
          .thenReturn(TvShowListLoadingState());
      await tester.pumpWidget(makeTestableWidget(NowPlayingTvShowsPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvShowBloc.state)
          .thenReturn(TvShowListLoadedState(testTvShowList));

      await tester.pumpWidget(makeTestableWidget(NowPlayingTvShowsPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvShowBloc.state)
          .thenReturn(TvShowListErrorState('Error'));

      await tester.pumpWidget(makeTestableWidget(NowPlayingTvShowsPage()));

      expect(find.text('Error'), findsOneWidget);
    });
  });
}
