import 'package:bloc/bloc.dart';
import '../../../../domain/usecases/get_watchlist_movies.dart';
import '../../../../domain/usecases/get_watchlist_tv_show.dart';
import 'tv_show_list_event.dart';
import 'tv_show_list_state.dart';

class WatchlistTvShowsBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetWatchlistTvShows getWatchlistTvShows;

  WatchlistTvShowsBloc(this.getWatchlistTvShows) : super(TvShowListInitialState()) {
    on<FetchWatchlistTvShowsEvent>((event, emit) async {
      emit(TvShowListLoadingState());

      final result = await getWatchlistTvShows.execute();

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

