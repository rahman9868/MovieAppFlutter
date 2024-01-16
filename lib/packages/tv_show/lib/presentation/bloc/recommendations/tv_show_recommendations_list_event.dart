import 'package:equatable/equatable.dart';

abstract class TvShowRecommendationListEvent extends Equatable {
  const TvShowRecommendationListEvent();

  @override
  List<Object> get props => [];
}

class FetchTvShowRecommendationsEvent extends TvShowRecommendationListEvent {
  final int id;

  FetchTvShowRecommendationsEvent(this.id);
}
