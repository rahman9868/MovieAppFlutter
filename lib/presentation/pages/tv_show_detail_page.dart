import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_show/recommendations/tv_show_recommendations_list_state.dart';
import 'package:ditonton/presentation/bloc/tv_show/watchlist_status/watchlist_tv_show_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../domain/entities/tv_show/tv_show_detail.dart';
import '../bloc/tv_show/detail/tv_show_detail_bloc.dart';
import '../bloc/tv_show/detail/tv_show_detail_event.dart';
import '../bloc/tv_show/detail/tv_show_detail_state.dart';

class TvShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show/detail';

  final int id;

  TvShowDetailPage({required this.id});

  @override
  _TvShowDetailPageState createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      context.read<TvShowDetailBloc>().add(FetchTvShowDetailEvent(widget.id));
      context
          .read<TvShowRecommendationListBloc>()
          .add(FetchTvShowRecommendationsEvent(widget.id));
      context.read<WatchlistStatusTvShowCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
          builder: (context, state) {
            if (state is TvShowDetailLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowDetailLoadedState) {
              return SafeArea(
                child: DetailContent(state.tvShow),
              );
            } else if (state is TvShowDetailErrorState) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Text('Failed $state');
            }
          },
        ));
  }
}

class DetailContent extends StatefulWidget {
  final TvShowDetail tvShow;

  DetailContent(this.tvShow);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${widget.tvShow.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tvShow.name,
                              style: kHeading5,
                            ),
                            BlocBuilder<WatchlistStatusTvShowCubit,
                                    WatchlistStatusTvShowState>(
                                builder: (context, state) {
                              bool isAddedWatchlist = state.isAddedWatchlist;
                              return ElevatedButton(
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    await context
                                        .read<WatchlistStatusTvShowCubit>()
                                        .addWatchlistTvShow(widget.tvShow);
                                  } else {
                                    await context
                                        .read<WatchlistStatusTvShowCubit>()
                                        .removeFromWatchlistTvShow(widget.tvShow);
                                  }

                                  final message = context
                                      .read<WatchlistStatusTvShowCubit>()
                                      .state
                                      .message;

                                  if (message ==
                                          WatchlistStatusTvShowCubit
                                              .watchlistAddSuccessMessage ||
                                      message ==
                                          WatchlistStatusTvShowCubit
                                              .watchlistRemoveSuccessMessage) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Text(message),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text(' Watchlist'),
                                  ],
                                ),
                              );
                            }),
                            Text(
                              _showGenres(widget.tvShow.genres),
                            ),
                            Text("${widget.tvShow.numberOfEpisodes} Episodes"),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tvShow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tvShow.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tvShow.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvShowRecommendationListBloc,
                                    TvShowRecommendationListState>(
                                builder: (context, state) {
                              if (state
                                  is TvShowRecommendationListLoadingState) {
                                return CircularProgressIndicator();
                              } else if (state
                                  is TvShowRecommendationListLoadedState) {
                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final tvShow = state.tvShows[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              TvShowDetailPage.ROUTE_NAME,
                                              arguments: tvShow.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: state.tvShows.length,
                                  ),
                                );
                              } else if (state
                                  is TvShowRecommendationListErrorState) {
                                return Text(state.message);
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
