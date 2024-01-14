import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';

import '../../../../domain/usecases/get_top_rated_tv_shows.dart';
import 'tv_show_list_event.dart';
import 'tv_show_list_state.dart';

class TopRatedTvShowsBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetTopRatedTvShows getTopRatedTvShows;

  TopRatedTvShowsBloc(this.getTopRatedTvShows) : super(TvShowListInitialState()) {
    on<FetchTopRatedTvShowsEvent>((event, emit) async {
      emit(TvShowListLoadingState());

      final result = await getTopRatedTvShows.execute();

      result.fold(
            (failure) {
          emit(TvShowListErrorState(failure.message));
        },
            (movies) {
          emit(TvShowListLoadedState(movies));
        },
      );
    }
    );
  }
}

