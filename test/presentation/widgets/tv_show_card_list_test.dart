import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('TvShowCard widget is rendered', (WidgetTester tester) async {
    final MockTvShowDetailNotifier mockNotifier = MockTvShowDetailNotifier();

    when(mockNotifier.tvShowState).thenReturn(RequestState.Loaded);
    when(mockNotifier.episodeState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvShow).thenReturn(testTvShowDetail);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<TvShowDetailNotifier>(
            create: (_) => mockNotifier,
            child: TvShowCard(testTvShow),
          ),
        ),
      ),
    );

    expect(find.byType(TvShowCard), findsOneWidget);

  });
}



