import 'package:equatable/equatable.dart';

abstract class SearchTvShowEvent extends Equatable {
  const SearchTvShowEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchTvShowEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
