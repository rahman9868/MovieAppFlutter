import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/presentation/widgets/seasons_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/tv_show/tv_show.dart';
import '../../domain/entities/tv_show/tv_show_detail.dart';
import '../bloc/tv_show/detail/tv_show_detail_bloc.dart';
import '../bloc/tv_show/detail/tv_show_detail_event.dart';
import '../bloc/tv_show/detail/tv_show_detail_state.dart';
import '../provider/tv_show_detail_notifier.dart';

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
  int selectedSeasonNumber = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {

      context.read<TvShowDetailBloc>().add(FetchTvShowDetailEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail TV Show"),
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Episodes'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetails(),

                  _buildEpisodes(),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildDetails() {
    return BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
      builder: (context, state) {
        if (state is TvShowDetailLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvShowDetailLoadedState) {
          final tvShow = state.tvShow;
          final tvShowsRecommendation = state.tvShowRecommendations;
          final isAddedToWatchlist = state.isAddedToWatchlist;
          return SafeArea(
            child: DetailContent(
              tvShow,
              tvShowsRecommendation,
              isAddedToWatchlist,
            ),
          );
        } else if (state is TvShowDetailErrorState) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Text('Failed $state');
        }
      },
    );
  }

  Widget _buildEpisodes() {
    return SeasonsList();
  }
}

class DetailContent extends StatelessWidget {
  final TvShowDetail tvShow;
  final List<TvShow> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tvShow, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
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
                              tvShow.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvShowDetailBloc>()
                                      .add(AddWatchlistEvent(tvShow));
                                } else {
                                  context
                                      .read<TvShowDetailBloc>()
                                      .add(RemoveFromWatchlistEvent(tvShow));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            BlocListener<TvShowDetailBloc, TvShowDetailState>(
                              listener: (context, state) {
                                if (state is TvShowDetailLoadedState) {
                                  final message = state.message;
                                  if(state.isUpdateWatchlist){
                                    if(state.isSuccessUpdateWatchlist){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(message)));
                                    }else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(message),
                                            );
                                          });
                                    }
                                  }
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            Text(
                              _showGenres(tvShow.genres),
                            ),
                            Text("${tvShow.numberOfEpisodes} Episodes"),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvShow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvShow.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvShow.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<TvShowDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvShow = recommendations[index];
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
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
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
