import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';


abstract class MovieRecommendationListState extends Equatable {
  const MovieRecommendationListState();

  @override
  List<Object> get props => [];
}

class MovieRecommendationListInitialState
    extends MovieRecommendationListState {}

class MovieRecommendationListLoadingState
    extends MovieRecommendationListState {}

class MovieRecommendationListLoadedState extends MovieRecommendationListState {
  final List<Movie> movies;

  MovieRecommendationListLoadedState(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieRecommendationListErrorState extends MovieRecommendationListState {
  final String message;

  MovieRecommendationListErrorState(this.message);

  @override
  List<Object> get props => [message];
}
