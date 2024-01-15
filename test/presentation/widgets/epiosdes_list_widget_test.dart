import 'package:ditonton/domain/entities/tv_show/episode.dart';
import 'package:ditonton/presentation/widgets/episodes_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('EpisodesList widget renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EpisodesList(testEpisodesList),
        ),
      ),
    );

    for (Episode episode in testEpisodesList) {
      expect(find.text('${episode.episodeNumber}. ${episode.name}'),
          findsOneWidget);
    }

    expect(find.byType(Divider), findsNWidgets(testEpisodesList.length));
  });
}
