import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:equatable/equatable.dart';


abstract class SearchTvShowState extends Equatable {
  const SearchTvShowState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchTvShowState {}

class SearchLoading extends SearchTvShowState {}

class SearchError extends SearchTvShowState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchTvShowState {
  final List<TvShow> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}