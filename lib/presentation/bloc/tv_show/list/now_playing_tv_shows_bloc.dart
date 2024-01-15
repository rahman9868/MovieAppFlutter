import 'package:bloc/bloc.dart';

import '../../../../domain/usecases/get_now_playing_tv_shows.dart';
import 'tv_show_list_event.dart';
import 'tv_show_list_state.dart';

class NowPlayingTvShowsBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetNowPlayingTvShows getNowPlayingTvShows;

  NowPlayingTvShowsBloc(this.getNowPlayingTvShows)
      : super(TvShowListInitialState()) {
    on<FetchNowPlayingTvShowsEvent>((event, emit) async {
      emit(TvShowListLoadingState());

      final result = await getNowPlayingTvShows.execute();

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
