import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv_show/episode.dart';
import '../../../../domain/entities/tv_show/tv_show.dart';
import '../../../../domain/entities/tv_show/tv_show_detail.dart';

abstract class TvShowDetailState extends Equatable {
  const TvShowDetailState();

  @override
  List<Object> get props => [];
}

class TvShowDetailInitialState extends TvShowDetailState {}

class TvShowDetailLoadingState extends TvShowDetailState {}

class TvShowDetailLoadedState extends TvShowDetailState {
  final TvShowDetail tvShow;

  TvShowDetailLoadedState(this.tvShow);
}

class TvShowDetailErrorState extends TvShowDetailState {
  final String message;

  TvShowDetailErrorState(this.message);
}