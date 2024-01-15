import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/list/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/movie/list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/popular_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/tv_show_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/tv_show_list_state.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularTvShowBloc
    extends MockBloc<TvShowListEvent, TvShowListState>
    implements PopularTvShowsBloc {}

class PopularTvShowsEventFake extends Fake implements TvShowListEvent {}

class PopularTvShowsStateFake extends Fake implements TvShowListState {}

void main() {
  late MockPopularTvShowBloc mockPopularTvShowBloc;

  setUpAll(() {
    registerFallbackValue(PopularTvShowsEventFake());
    registerFallbackValue(PopularTvShowsStateFake());
  });

  setUp(() {
    mockPopularTvShowBloc = MockPopularTvShowBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvShowsBloc>.value(
      value: mockPopularTvShowBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TvShow Page, Popular TvShow Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockPopularTvShowBloc.state)
          .thenReturn(TvShowListInitialState());
      await tester.pumpWidget(makeTestableWidget(PopularTvShowsPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockPopularTvShowBloc.state)
              .thenReturn(TvShowListLoadingState());
          await tester.pumpWidget(makeTestableWidget(PopularTvShowsPage()));

          final progressBarFinder = find.byType(CircularProgressIndicator);
          final centerFinder = find.byType(Center);

          expect(centerFinder, findsOneWidget);
          expect(progressBarFinder, findsOneWidget);
        });

    testWidgets('page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockPopularTvShowBloc.state)
              .thenReturn(TvShowListLoadedState(testTvShowList));

          await tester.pumpWidget(makeTestableWidget(PopularTvShowsPage()));

          final listViewFinder = find.byType(ListView);
          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockPopularTvShowBloc.state)
              .thenReturn(TvShowListErrorState('Error'));

          await tester.pumpWidget(makeTestableWidget(PopularTvShowsPage()));

          expect(find.text('Error'), findsOneWidget);
        });
  });
}
