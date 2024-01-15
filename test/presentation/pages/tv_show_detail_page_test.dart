import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_state.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_state.dart';
import 'package:ditonton/presentation/bloc/tv_show/watchlist_status/watchlist_tv_show_status_cubit.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvShowDetailBloc
    extends MockBloc<TvShowDetailEvent, TvShowDetailState>
    implements TvShowDetailBloc {}

class TvShowDetailEventFake extends Fake implements TvShowDetailEvent {}

class TvShowDetailStateFake extends Fake implements TvShowDetailState {}

class MockTvShowRecommendationListBloc extends MockBloc<
    TvShowRecommendationListEvent,
    TvShowRecommendationListState> implements TvShowRecommendationListBloc {}

class RecommendationTvEventFake extends Fake
    implements TvShowRecommendationListEvent {}

class RecommendationTvStateFake extends Fake
    implements TvShowRecommendationListState {}

class MockWatchlistStatusTvShowCubit
    extends MockCubit<WatchlistStatusTvShowState>
    implements WatchlistStatusTvShowCubit {}

class WatchlistStatusTvShowStateFake extends Fake
    implements WatchlistStatusTvShowState {}

void main() {
  late MockTvShowDetailBloc mockTvShowDetailBloc;
  late MockTvShowRecommendationListBloc mockTvShowRecommendationListBloc;
  late MockWatchlistStatusTvShowCubit mockWatchlistStatusTvShowCubit;

  setUpAll(() {
    registerFallbackValue(TvShowDetailEventFake());
    registerFallbackValue(TvShowDetailStateFake());
  });

  setUp(() {
    mockTvShowDetailBloc = MockTvShowDetailBloc();
    mockTvShowRecommendationListBloc = MockTvShowRecommendationListBloc();
    mockWatchlistStatusTvShowCubit = MockWatchlistStatusTvShowCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvShowDetailBloc>.value(value: mockTvShowDetailBloc),
        BlocProvider<TvShowRecommendationListBloc>.value(
            value: mockTvShowRecommendationListBloc),
        BlocProvider<WatchlistStatusTvShowCubit>.value(
          value: mockWatchlistStatusTvShowCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Detail TV Page:', () {
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockTvShowDetailBloc.state)
          .thenReturn(TvShowDetailLoadingState());
      when(() => mockWatchlistStatusTvShowCubit.state).thenReturn(
          const WatchlistStatusTvShowState(
              isAddedWatchlist: false, message: ''));
      when(() => mockTvShowRecommendationListBloc.state)
          .thenReturn(TvShowRecommendationListLoadingState());

      await tester.pumpWidget(
          makeTestableWidget(TvShowDetailPage(id: testTvShowDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);

      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTvShowDetailBloc.state)
          .thenReturn(TvShowDetailLoadedState(testTvShowDetail));
      when(() => mockWatchlistStatusTvShowCubit.state).thenReturn(
          const WatchlistStatusTvShowState(
              isAddedWatchlist: false, message: ''));
      when(() => mockTvShowRecommendationListBloc.state)
          .thenReturn(TvShowRecommendationListLoadedState(testTvShowList));

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(
        id: testTvShowDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);

      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTvShowDetailBloc.state)
          .thenReturn(TvShowDetailErrorState('Error'));
      when(() => mockWatchlistStatusTvShowCubit.state).thenReturn(
          const WatchlistStatusTvShowState(
              isAddedWatchlist: false, message: ''));
      when(() => mockTvShowRecommendationListBloc.state)
          .thenReturn(TvShowRecommendationListErrorState('Error'));

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(
        id: testTvShowDetail.id,
      )));

      expect(find.text('Error'), findsOneWidget);
    });
  });

  group('TV Page, Detail TV Widgets:', () {
    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockTvShowDetailBloc.state)
          .thenReturn(TvShowDetailLoadedState(testTvShowDetail));
      when(() => mockWatchlistStatusTvShowCubit.state).thenReturn(
          const WatchlistStatusTvShowState(
              isAddedWatchlist: false, message: ''));
      when(() => mockTvShowRecommendationListBloc.state)
          .thenReturn(TvShowRecommendationListLoadedState(testTvShowList));

      await tester.pumpWidget(
          makeTestableWidget(TvShowDetailPage(id: testTvShowDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockTvShowDetailBloc.state)
          .thenReturn(TvShowDetailLoadedState(testTvShowDetail));
      when(() => mockWatchlistStatusTvShowCubit.state).thenReturn(
          const WatchlistStatusTvShowState(
              isAddedWatchlist: true, message: ''));
      when(() => mockTvShowRecommendationListBloc.state)
          .thenReturn(TvShowRecommendationListLoadedState(testTvShowList));

      await tester.pumpWidget(
          makeTestableWidget(TvShowDetailPage(id: testTvShowDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
