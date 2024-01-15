import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('MovieCard widget is rendered', (WidgetTester tester) async {
    final MockMovieDetailNotifier mockNotifier = MockMovieDetailNotifier();

    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<MovieDetailNotifier>(
            create: (_) => mockNotifier,
            child: MovieCard(testMovie),
          ),
        ),
      ),
    );

    expect(find.byType(MovieCard), findsOneWidget);

  });
}



