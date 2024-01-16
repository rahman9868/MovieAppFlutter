import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/domain/usecases/get_tv_show_recommendations.dart';
import 'tv_show_recommendations_list_event.dart';
import 'tv_show_recommendations_list_state.dart';

class TvShowRecommendationListBloc
    extends Bloc<TvShowRecommendationListEvent, TvShowRecommendationListState> {
  final GetTvShowRecommendations getTvShowRecommendations;

  TvShowRecommendationListBloc(this.getTvShowRecommendations)
      : super(TvShowRecommendationListInitialState()) {
    on<FetchTvShowRecommendationsEvent>((event, emit) async {
      emit(TvShowRecommendationListLoadingState());

      final result = await getTvShowRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(TvShowRecommendationListErrorState(failure.message));
        },
        (movies) {
          emit(TvShowRecommendationListLoadedState(movies));
        },
      );
    });
  }
}
