import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_show/presentation/bloc/search/search_tv_show_bloc.dart';
import 'package:tv_show/presentation/bloc/search/search_tv_show_event.dart';
import 'package:tv_show/presentation/bloc/search/search_tv_show_state.dart';
import 'package:tv_show/presentation/pages/search_page_tv_show.dart';

import '../../dummy_data/dummy_objects.dart';


class MockSearchTvShowBloc extends MockBloc<SearchTvShowEvent, SearchTvShowState>
    implements SearchTvShowBloc {}

class SearchTvShowEventFake extends Fake implements SearchTvShowEvent {}

class SearchTvShowStateFake extends Fake implements SearchTvShowState {}

void main() {
  late MockSearchTvShowBloc mockSearchTvShowBloc;

  setUpAll(() {
    registerFallbackValue(SearchTvShowEventFake());
    registerFallbackValue(SearchTvShowStateFake());
  });

  setUp(() {
    mockSearchTvShowBloc = MockSearchTvShowBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvShowBloc>.value(
      value: mockSearchTvShowBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('SearchTvShow Page, SearchTvShow Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockSearchTvShowBloc.state)
          .thenReturn(SearchEmpty());
      await tester.pumpWidget(makeTestableWidget(SearchPageTvShow()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockSearchTvShowBloc.state)
              .thenReturn(SearchLoading());
          await tester.pumpWidget(makeTestableWidget(SearchPageTvShow()));

          final progressBarFinder = find.byType(CircularProgressIndicator);

          expect(progressBarFinder, findsOneWidget);
        });

    testWidgets('page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockSearchTvShowBloc.state)
              .thenReturn(SearchHasData(testTvShowList));

          await tester.pumpWidget(makeTestableWidget(SearchPageTvShow()));

          final listViewFinder = find.byType(ListView);
          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockSearchTvShowBloc.state)
              .thenReturn(SearchError('Error'));

          await tester.pumpWidget(makeTestableWidget(SearchPageTvShow()));

          expect(find.text('Error'), findsOneWidget);
        });
  });
}
