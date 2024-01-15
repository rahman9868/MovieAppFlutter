
import 'package:ditonton/domain/entities/tv_show/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistStatusTvShowCubit extends Cubit<WatchlistStatusTvShowState> {
  final GetWatchListStatusTvShow getWatchlistTvShowStatus;
  final SaveWatchlistTvShow saveWatchlistTvShow;
  final RemoveWatchlistTvShow removeWatchlistTvShow;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistStatusTvShowCubit({
    required this.getWatchlistTvShowStatus,
    required this.saveWatchlistTvShow,
    required this.removeWatchlistTvShow,
  }) : super(
      const WatchlistStatusTvShowState(isAddedWatchlist: false, message: ''));

  void loadWatchlistStatus(int id) async {
    final result = await getWatchlistTvShowStatus.execute(id);
    emit(WatchlistStatusTvShowState(isAddedWatchlist: result, message: ''));
  }

  Future<void> addWatchlistTV(TvShowDetail tvShowDetail) async {
    final result = await saveWatchlistTvShow.execute(tvShowDetail);
    final getStatus = await getWatchlistTvShowStatus.execute(tvShowDetail.id);

    result.fold(
          (failure) => emit(WatchlistStatusTvShowState(
          isAddedWatchlist: getStatus, message: failure.message)),
          (data) => emit(
          WatchlistStatusTvShowState(isAddedWatchlist: getStatus, message: data)),
    );
  }

  Future<void> removeFromWatchlistTV(TvShowDetail tvShowDetail) async {
    final result = await removeWatchlistTvShow.execute(tvShowDetail);
    final getStatus = await getWatchlistTvShowStatus.execute(tvShowDetail.id);

    result.fold(
          (failure) => emit(WatchlistStatusTvShowState(
          isAddedWatchlist: getStatus, message: failure.message)),
          (data) => emit(
          WatchlistStatusTvShowState(isAddedWatchlist: getStatus, message: data)),
    );
  }
}

class WatchlistStatusTvShowState extends Equatable {
  final bool isAddedWatchlist;
  final String message;

  const WatchlistStatusTvShowState({
    required this.isAddedWatchlist,
    required this.message,
  });

  @override
  List<Object> get props => [isAddedWatchlist];
}
