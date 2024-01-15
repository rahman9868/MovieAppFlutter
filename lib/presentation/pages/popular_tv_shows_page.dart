import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_show/list/popular_tv_shows_bloc.dart';
import '../bloc/tv_show/list/tv_show_list_event.dart';
import '../bloc/tv_show/list/tv_show_list_state.dart';
import '../widgets/tv_show_card_list.dart';

class PopularTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-show';

  @override
  _PopularTvShowsPageState createState() => _PopularTvShowsPageState();
}

class _PopularTvShowsPageState extends State<PopularTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularTvShowsBloc>().add(FetchPopularTvShowsEvent())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TvShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvShowsBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowListLoadedState) {
              final tvShow = state.tvShows;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = tvShow[index];
                  return TvShowCard(movie);
                },
                itemCount: tvShow.length,
              );
            } else if (state is TvShowListErrorState) {
              return Center(
                  child: Text(state.message),
              );
            } else {
              return Text('Failed');
            }
          },
        ),
      ),
    );
  }
}
