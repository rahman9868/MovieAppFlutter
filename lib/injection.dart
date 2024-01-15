import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/movie/tv_show_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movies_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_status_cubit.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/episode/tv_show_episode_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/now_playing_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/popular_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/top_rated_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/search/search_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/watchlist_status/watchlist_tv_show_status_cubit.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_show_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_shows_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_show_notifier.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_show_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_show_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'domain/usecases/get_now_playing_tv_shows.dart';
import 'domain/usecases/get_popular_tv_shows.dart';
import 'domain/usecases/get_top_rated_tv_shows.dart';
import 'domain/usecases/get_tv_show_detail.dart';
import 'domain/usecases/get_tv_show_episodes.dart';
import 'domain/usecases/get_tv_show_recommendations.dart';
import 'domain/usecases/search_tv_shows.dart';
import 'presentation/bloc/tv_show/watchlist/watchlist_tv_shows_bloc.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TvShowListNotifier(
      getNowPlayingTvShows: locator(),
      getPopularTvShows: locator(),
      getTopRatedTvShows: locator(),
    ),
  );
  locator.registerFactory(
    () => TvShowDetailNotifier(
      getTvShowDetail: locator(),
      getTvShowEpisodes: locator(),
      getTvShowRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvShowSearchNotifier(
      searchTvShows: locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingTvShowsNotifier(
      getNowPlayingTvShows: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvShowsNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvShowsNotifier(
      getTopRatedTvShows: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvShowNotifier(
      getWatchlistTvShows: locator(),
    ),
  );

  //bloc
  locator.registerFactory(
        () => SearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => NowPlayingMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => PopularMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TopRatedMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistMoviesBloc(
          locator(),
          locator(),
          locator(),
          locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistStatusMovieCubit(
      getWatchListStatus: locator(),
      removeWatchlist: locator(),
      saveWatchlist: locator(),
    ),
  );
  locator.registerFactory(
        () => MovieDetailBloc(
            locator(),
        ),
  );
  locator.registerFactory(
        () => MovieRecommendationListBloc(
            locator(),
        ),
  );
  locator.registerFactory(
        () => SearchTvShowBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => NowPlayingTvShowsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => PopularTvShowsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TopRatedTvShowsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistTvShowsBloc(
      locator(),
          locator(),
          locator(),
          locator(),
    ),
  );
  locator.registerFactory(
        () => TvShowDetailBloc(
        locator(),
        locator()
    ),
  );
  locator.registerFactory(
        () => TvShowEpisodeBloc(
        locator()
    ),
  );
  locator.registerFactory(
        () => TvShowRecommendationListBloc(
        locator()
    ),
  );
  locator.registerFactory(
        () => WatchlistStatusTvShowCubit(
      getWatchlistTvShowStatus: locator(),
      saveWatchlistTvShow: locator(),
      removeWatchlistTvShow: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTvShows(locator()));
  locator.registerLazySingleton(() => GetPopularTvShows(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShows(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => GetTvShowRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvShows(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvShow(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvShow(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvShows(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvShow(locator()));
  locator.registerLazySingleton(() => GetTvShowEpisodes(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvShowRepository>(
    () => TvShowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvShowRemoteDataSource>(
      () => TvShowRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvShowLocalDataSource>(
      () => TvShowLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
