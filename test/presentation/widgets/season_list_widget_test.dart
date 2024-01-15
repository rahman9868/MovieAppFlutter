
import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_show/episode/tv_show_episode_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/episode/tv_show_episode_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/episode/tv_show_episode_state.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/seasons_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvShowEpisodeBloc extends MockBloc<TvShowEpisodeEvent, TvShowEpisodeState>
    implements TvShowEpisodeBloc {}

class TvShowEpisodeEventFake extends Fake implements TvShowEpisodeEvent {}

class TvShowEpisodeStateFake extends Fake implements TvShowEpisodeState {}

void main() {
  late MockTvShowEpisodeBloc mockTvShowEpisodeBloc;

  setUpAll(() {
    registerFallbackValue(TvShowEpisodeEventFake());
    registerFallbackValue(TvShowEpisodeStateFake());
  });
  
  setUp(() {
    mockTvShowEpisodeBloc = MockTvShowEpisodeBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvShowEpisodeBloc>.value(
      value: mockTvShowEpisodeBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }
  
  group('SeasonsList Widget Tests', () {
    
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockTvShowEpisodeBloc.state)
          .thenReturn(TvShowEpisodeInitialState());
      await tester.pumpWidget(makeTestableWidget(SeasonsList(tvShowDetail: testTvShowDetail)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('Renders loading state', (WidgetTester tester) async {
      when(() => mockTvShowEpisodeBloc.state).thenReturn(TvShowEpisodesLoadingState());

      await tester.pumpWidget(makeTestableWidget(SeasonsList(tvShowDetail: testTvShowDetail)));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Renders success state', (WidgetTester tester) async {
      when(() => mockTvShowEpisodeBloc.state).thenReturn(EpisodesTvShowSuccessState(
        testEpisodesMap,
        testTvShowDetail,
        testIsExpandedMap
      ));

      await tester.pumpWidget(makeTestableWidget(SeasonsList(tvShowDetail: testTvShowDetail)));

      expect(find.text('Season 1'), findsOneWidget);
      // Add more expectations based on your widget's UI
    });

    testWidgets('Renders error state', (WidgetTester tester) async {
      when(() => mockTvShowEpisodeBloc.state).thenReturn(EpisodesTvShowErrorState('Error message'));

      await tester.pumpWidget(makeTestableWidget(SeasonsList(tvShowDetail: testTvShowDetail)));

      expect(find.text('Error message'), findsOneWidget);
    });

  });
}