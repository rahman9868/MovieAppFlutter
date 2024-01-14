import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_event.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_list_state.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movies_recommendations_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movies_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../bloc/movie/detail/movie_detail_state.dart';
import '../bloc/movie/watchlist/watchlist_movies_state.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;

  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(FetchMovieDetailEvent(widget.id));
      context.read<MovieRecommendationListBloc>().add(FetchMovieRecommendationsEvent(widget.id));
      context.read<WatchlistMoviesBloc>().add(WatchlistMoviesStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
            builder: (context, state) {
              if (state is MovieDetailLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MovieDetailLoadedState) {
                final movie = state.movie;
                return SafeArea(
                  child: DetailContent(
                    movie,
                  ),
                );
              } else if (state is MovieDetailErrorState) {
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
        );
  }
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;

  DetailContent(this.movie);

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
            imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
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
                                widget.movie.title,
                                style: kHeading5,
                              ),
                              BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        if (state is WatchListMovieResponse){
                                          if (state.isWatchlist){
                                            context
                                                .read<WatchlistMoviesBloc>()
                                                .add(WatchlistMoviesRemove(widget.movie));
                                          } else {
                                            context
                                                .read<WatchlistMoviesBloc>()
                                                .add(WatchlistMoviesAdd(widget.movie));
                                          }
                                        } else {
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (state is WatchListMovieResponse)
                                            if(state.isWatchlist)
                                              Icon(Icons.check)
                                            else
                                              Icon(Icons.add),
                                          Text('Watchlist'),
                                        ],
                                      ),
                                    );
                                  }),
                              BlocListener<WatchlistMoviesBloc, WatchlistMoviesState>(
                                listener: (context, state) {
                                  if (state is WatchListMovieResponse) {
                                    final message = state.message;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  }
                                  else if (state is WatchlistMoviesErrorState){
                                    final message = state.message;
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(message),
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            Text(
                                _showGenres(widget.movie.genres),
                              ),
                              Text(
                                _showDuration(widget.movie.runtime),
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.movie.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${widget.movie.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                widget.movie.overview,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              BlocBuilder<MovieRecommendationListBloc, MovieRecommendationListState>(
                              builder: (context, state) {
                                if (state is MovieRecommendationListLoadingState){
                                  return CircularProgressIndicator();
                                } else if (state is MovieRecommendationListLoadedState){
                                  return Container(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final movie = state.movies[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  MovieDetailPage.ROUTE_NAME,
                                                  arguments: movie.id,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                                        itemCount: state.movies.length,
                                      ),
                                    );
                                } else if (state is MovieRecommendationListErrorState){
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
