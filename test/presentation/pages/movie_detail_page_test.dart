import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_state.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_state.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movies_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_status/watchlist_movie_status_cubit.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MockMovieRecommendationListBloc
    extends MockBloc<MovieRecommendationListEvent, MovieRecommendationListState>
    implements MovieRecommendationListBloc {}

class MovieRecommendationListEventFake extends Fake
    implements MovieRecommendationListEvent {}

class MovieRecommendationListStateFake extends Fake
    implements MovieRecommendationListState {}

class MockWatchlistStatusMovieCubit extends MockCubit<WatchlistStatusMovieState>
    implements WatchlistStatusMovieCubit {}

class WatchlistStatusMovieStateFake extends Fake
    implements WatchlistStatusMovieState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationListBloc mockRecommendationListBloc;
  late MockWatchlistStatusMovieCubit mockWatchlistStatusMovieCubit;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockRecommendationListBloc = MockMovieRecommendationListBloc();
    mockWatchlistStatusMovieCubit = MockWatchlistStatusMovieCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationListBloc>.value(
            value: mockRecommendationListBloc),
        BlocProvider<WatchlistStatusMovieCubit>.value(
          value: mockWatchlistStatusMovieCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Detail Movie Page:', () {
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoadingState());
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationListBloc.state)
          .thenReturn(MovieRecommendationListLoadingState());

      await tester.pumpWidget(
          makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoadedState(testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationListBloc.state)
          .thenReturn(MovieRecommendationListLoadedState(testMovieList));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailErrorState('Error'));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationListBloc.state)
          .thenReturn(MovieRecommendationListErrorState('Error'));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('Movie Page, Detail Movie Widgets:', () {
    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoadedState(testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationListBloc.state)
          .thenReturn(MovieRecommendationListLoadedState(testMovieList));

      await tester.pumpWidget(
          makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoadedState(testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(isAddedWatchlist: true, message: ''));
      when(() => mockRecommendationListBloc.state)
          .thenReturn(MovieRecommendationListLoadedState(testMovieList));

      await tester.pumpWidget(
          makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
