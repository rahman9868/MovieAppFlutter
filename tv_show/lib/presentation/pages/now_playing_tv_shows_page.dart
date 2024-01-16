import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_show/presentation/bloc/list/now_playing_tv_shows_bloc.dart';
import 'package:tv_show/presentation/bloc/list/tv_show_list_event.dart';

import 'package:tv_show/presentation/bloc/list/tv_show_list_state.dart';
import 'package:tv_show/presentation/widgets/tv_show_card_list.dart';


class NowPlayingTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/now_playing-tv-show';

  @override
  _NowPlayingTvShowsPageState createState() => _NowPlayingTvShowsPageState();
}

class _NowPlayingTvShowsPageState extends State<NowPlayingTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<NowPlayingTvShowsBloc>()
        .add(FetchNowPlayingTvShowsEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing TvShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvShowsBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowListLoadedState) {
              final tvShows = state.tvShows;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = tvShows[index];
                  return TvShowCard(tvShow);
                },
                itemCount: tvShows.length,
              );
            } else if (state is TvShowListErrorState) {
              return Center(child: Text(state.message));
            } else {
              return Text('Failed');
            }
          },
        ),
      ),
    );
  }
}
