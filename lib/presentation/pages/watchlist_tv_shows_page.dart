import 'package:ditonton/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_show/list/tv_show_list_event.dart';
import '../bloc/tv_show/list/tv_show_list_state.dart';
import '../bloc/tv_show/list/watchlist_tvShows_bloc.dart';
import '../widgets/tv_show_card_list.dart';

class WatchlistTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv-show';

  @override
  _WatchlistTvShowsPageState createState() => _WatchlistTvShowsPageState();
}

class _WatchlistTvShowsPageState extends State<WatchlistTvShowsPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistTvShowsBloc>().add(FetchWatchlistTvShowsEvent())
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistTvShowsBloc>().add(FetchWatchlistTvShowsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvShowsBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowListLoadedState) {
              final tvShows = state.tvShows;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = tvShows[index];
                  return TvShowCard(movie);
                },
                itemCount: tvShows.length,
              );
            } else if (state is TvShowListErrorState) {
              return Expanded(
                child: Center(
                  child: Text(state.message),
                ),
              );
            } else {
              return Text('Failed');
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
