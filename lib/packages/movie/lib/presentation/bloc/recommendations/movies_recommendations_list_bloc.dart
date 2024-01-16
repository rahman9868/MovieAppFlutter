import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_recommendations_list_event.dart';
import 'movie_recommendations_list_state.dart';

class MovieRecommendationListBloc
    extends Bloc<MovieRecommendationListEvent, MovieRecommendationListState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationListBloc(this.getMovieRecommendations)
      : super(MovieRecommendationListInitialState()) {
    on<FetchMovieRecommendationsEvent>((event, emit) async {
      emit(MovieRecommendationListLoadingState());

      final result = await getMovieRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(MovieRecommendationListErrorState(failure.message));
        },
        (movies) {
          emit(MovieRecommendationListLoadedState(movies));
        },
      );
    });
  }
}
