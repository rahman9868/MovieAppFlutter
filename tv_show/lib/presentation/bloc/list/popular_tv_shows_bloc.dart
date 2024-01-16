import 'package:bloc/bloc.dart';

import 'package:core/domain/usecases/get_popular_tv_shows.dart';
import 'tv_show_list_event.dart';
import 'tv_show_list_state.dart';

class PopularTvShowsBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetPopularTvShows getPopularTvShows;

  PopularTvShowsBloc(this.getPopularTvShows) : super(TvShowListInitialState()) {
    on<FetchPopularTvShowsEvent>((event, emit) async {
      emit(TvShowListLoadingState());

      final result = await getPopularTvShows.execute();

      result.fold(
        (failure) {
          emit(TvShowListErrorState(failure.message));
        },
        (movies) {
          emit(TvShowListLoadedState(movies));
        },
      );
    });
  }
}
