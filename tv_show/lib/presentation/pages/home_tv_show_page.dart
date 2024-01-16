import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv_show/tv_show.dart';
import 'package:tv_show/presentation/pages/now_playing_tv_shows_page.dart';
import 'package:tv_show/presentation/pages/popular_tv_shows_page.dart';
import 'package:tv_show/presentation/pages/search_page_tv_show.dart';
import 'package:tv_show/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:tv_show/presentation/pages/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tv_show/presentation/bloc/list/now_playing_tv_shows_bloc.dart';
import 'package:tv_show/presentation/bloc/list/popular_tv_shows_bloc.dart';
import 'package:tv_show/presentation/bloc/list/top_rated_tv_shows_bloc.dart';
import 'package:tv_show/presentation/bloc/list/tv_show_list_event.dart';
import 'package:tv_show/presentation/bloc/list/tv_show_list_state.dart';


class HomeTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show';

  @override
  _HomeTvShowPageState createState() => _HomeTvShowPageState();
}

class _HomeTvShowPageState extends State<HomeTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingTvShowsBloc>().add(FetchNowPlayingTvShowsEvent());
      context.read<PopularTvShowsBloc>().add(FetchPopularTvShowsEvent());
      context.read<TopRatedTvShowsBloc>().add(FetchTopRatedTvShowsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Show'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageTvShow.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => Navigator.pushNamed(
                    context, NowPlayingTvShowsPage.ROUTE_NAME),
              ),
              BlocBuilder<NowPlayingTvShowsBloc, TvShowListState>(
                builder: (context, state) {
                  if (state is TvShowListLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvShowListLoadedState) {
                    final result = state.tvShows;
                    return TvShowList(result);
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
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvShowsPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvShowsBloc, TvShowListState>(
                builder: (context, state) {
                  if (state is TvShowListLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvShowListLoadedState) {
                    final result = state.tvShows;
                    return TvShowList(result);
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
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                    context, TopRatedTvShowsPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvShowsBloc, TvShowListState>(
                builder: (context, state) {
                  if (state is TvShowListLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvShowListLoadedState) {
                    final result = state.tvShows;
                    return TvShowList(result);
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
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvShowList extends StatelessWidget {
  final List<TvShow> tvShows;

  TvShowList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvShowDetailPage.ROUTE_NAME,
                  arguments: tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
