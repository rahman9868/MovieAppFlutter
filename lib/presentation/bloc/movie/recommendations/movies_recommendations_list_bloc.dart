
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/get_movie_recommendations.dart';

class MovieRecommendationListBloc extends Bloc<MovieRecommendationListEvent, MovieRecommendationListState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationListBloc(this.getMovieRecommendations) : super(MovieRecommendationListInitialState()) {
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
    }
    );
  }

}