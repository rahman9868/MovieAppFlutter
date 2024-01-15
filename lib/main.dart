import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movies_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/now_playing_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/popular_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/list/top_rated_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/search/search_tv_show_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_show_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_page_tv_show.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_shows_page.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'presentation/bloc/tv_show/watchlist/watchlist_tv_shows_bloc.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NowPlayingMoviesBloc>(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        Provider<TopRatedMoviesBloc>(create: (_) => di.locator<TopRatedMoviesBloc>()),
        Provider<PopularMoviesBloc>(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvShowBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingTvShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvShowRecommendationListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvShowDetailBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case HomeTvShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvShowPage());
            case NowPlayingTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingTvShowsPage());
            case PopularTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvShowsPage());
            case TopRatedTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvShowsPage());
            case TvShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );
            case WatchlistTvShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvShowsPage());
            case SearchPageTvShow.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageTvShow());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
