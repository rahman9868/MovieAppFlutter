import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/tv_show.dart';

abstract class TvShowRecommendationListState extends Equatable {
  const TvShowRecommendationListState();

  @override
  List<Object> get props => [];
}

class TvShowRecommendationListInitialState
    extends TvShowRecommendationListState {}

class TvShowRecommendationListLoadingState
    extends TvShowRecommendationListState {}

class TvShowRecommendationListLoadedState
    extends TvShowRecommendationListState {
  final List<TvShow> tvShows;

  TvShowRecommendationListLoadedState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class TvShowRecommendationListErrorState extends TvShowRecommendationListState {
  final String message;

  TvShowRecommendationListErrorState(this.message);

  @override
  List<Object> get props => [message];
}
