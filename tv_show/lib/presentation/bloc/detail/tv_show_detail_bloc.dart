import 'package:core/domain/usecases/get_tv_show_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tv_show_detail_event.dart';
import 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail getTvShowDetail;

  TvShowDetailBloc(
    this.getTvShowDetail,
  ) : super(TvShowDetailInitialState()) {
    on<FetchTvShowDetailEvent>((event, emit) async {
      emit(TvShowDetailLoadingState());

      final result = await getTvShowDetail.execute(event.id);

      result.fold(
        (failure) {
          emit(TvShowDetailErrorState(failure.message));
        },
        (tvShow) {
          emit(TvShowDetailLoadedState(tvShow));
        },
      );
    });
  }
}
