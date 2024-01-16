import 'package:equatable/equatable.dart';

abstract class MovieRecommendationListEvent extends Equatable {
  const MovieRecommendationListEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieRecommendationsEvent extends MovieRecommendationListEvent {
  final int id;

  FetchMovieRecommendationsEvent(this.id);
}
