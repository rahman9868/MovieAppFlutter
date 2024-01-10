
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/seasons_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../pages/tv_show_detail_page_test.mocks.dart';

void main() {
  group('SeasonsList Widget Test', () {
    late MockTvShowDetailNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockTvShowDetailNotifier();
    });

    Widget buildSeasonsList() {
      return MaterialApp(
        home: ChangeNotifierProvider<TvShowDetailNotifier>(
          create: (_) => mockNotifier,
          child: SeasonsList(),
        ),
      );
    }

    testWidgets('renders loading indicator when TV show is loading',
            (WidgetTester tester) async {
          when(mockNotifier.tvShowState).thenReturn(RequestState.Loading);
          when(mockNotifier.episodeState).thenReturn(RequestState.Loaded);
          when(mockNotifier.tvShow).thenReturn(testTvShowDetail);

          await tester.pumpWidget(buildSeasonsList());

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });


    testWidgets('renders error message when TV show state is error',
            (WidgetTester tester) async {
          when(mockNotifier.tvShowState).thenReturn(RequestState.Error);
          when(mockNotifier.message).thenReturn('Error message');

          await tester.pumpWidget(buildSeasonsList());

          expect(find.text('Error message'), findsOneWidget);
        });


    testWidgets('tapping on a season triggers expansion', (WidgetTester tester) async {
      when(mockNotifier.tvShowState).thenReturn(RequestState.Loaded);
      when(mockNotifier.episodeState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvShow).thenReturn(testTvShowDetail);

      when(mockNotifier.isExpandedMap).thenReturn({1: false});
      when(mockNotifier.toggleSeasonExpansion(any)).thenAnswer((_) => {});

      await tester.pumpWidget(buildSeasonsList());

      await tester.tap(find.text('Season 1'));
      await tester.pump();

      verify(mockNotifier.toggleSeasonExpansion(1)).called(1);
    });
  });
}