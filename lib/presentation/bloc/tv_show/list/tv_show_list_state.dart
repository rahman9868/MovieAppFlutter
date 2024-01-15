import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/tv_show.dart';

abstract class TvShowListState extends Equatable {
  const TvShowListState();

  @override
  List<Object> get props => [];
}

class TvShowListInitialState extends TvShowListState {}

class TvShowListLoadingState extends TvShowListState {}

class TvShowListLoadedState extends TvShowListState {
  final List<TvShow> tvShows;

  TvShowListLoadedState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class TvShowListErrorState extends TvShowListState {
  final String message;

  TvShowListErrorState(this.message);

  @override
  List<Object> get props => [message];
}
