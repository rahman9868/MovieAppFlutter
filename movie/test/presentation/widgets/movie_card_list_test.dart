import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('MovieCard widget is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MovieCard(testMovie),
      ),
    ));
    expect(find.byType(MovieCard), findsOneWidget);
  });
}
