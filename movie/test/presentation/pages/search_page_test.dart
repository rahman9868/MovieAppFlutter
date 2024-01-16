import 'package:bloc_test/bloc_test.dart';
import 'package:movie/presentation/bloc/list/movie_list_event.dart';
import 'package:movie/presentation/bloc/list/movie_list_state.dart';
import 'package:movie/presentation/bloc/list/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/search/search_bloc.dart';
import 'package:movie/presentation/bloc/search/search_event.dart';
import 'package:movie/presentation/bloc/search/search_state.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/pages/search_page.dart';

import '../../dummy_data/dummy_objects.dart';


class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class SearchEventFake extends Fake implements SearchEvent {}

class SearchStateFake extends Fake implements SearchState {}

void main() {
  late MockSearchBloc mockSearchBloc;

  setUpAll(() {
    registerFallbackValue(SearchEventFake());
    registerFallbackValue(SearchStateFake());
  });

  setUp(() {
    mockSearchBloc = MockSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchBloc>.value(
      value: mockSearchBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Search Page, Search Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockSearchBloc.state)
          .thenReturn(SearchEmpty());
      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockSearchBloc.state)
              .thenReturn(SearchLoading());
          await tester.pumpWidget(makeTestableWidget(SearchPage()));

          final progressBarFinder = find.byType(CircularProgressIndicator);

          expect(progressBarFinder, findsOneWidget);
        });

    testWidgets('page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockSearchBloc.state)
              .thenReturn(SearchHasData(testMovieList));

          await tester.pumpWidget(makeTestableWidget(SearchPage()));

          final listViewFinder = find.byType(ListView);
          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockSearchBloc.state)
              .thenReturn(SearchError('Error'));

          await tester.pumpWidget(makeTestableWidget(SearchPage()));

          expect(find.text('Error'), findsOneWidget);
        });
  });
}
