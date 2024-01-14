import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../bloc/tv_show/detail/tv_show_detail_bloc.dart';
import '../bloc/tv_show/detail/tv_show_detail_state.dart';
import '../provider/tv_show_detail_notifier.dart';
import 'episodes_list_widget.dart';

class SeasonsList extends StatefulWidget {
  @override
  _SeasonsListState createState() => _SeasonsListState();
}

class _SeasonsListState extends State<SeasonsList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
      builder: (context, state) {
        if (state is TvShowEpisodesLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvShowDetailLoadedState) {
          final episodesMap = state.episodeMap;
          final tvShowDetail = state.tvShow;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(tvShowDetail.seasons.length, (index) {
                final season = tvShowDetail.seasons[index];
                /*if (provider.isExpandedMap.isEmpty) {
                  provider.initializeIsExpandedMap();
                }*/
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Season ${season.seasonNumber}',
                          ),
                          IconButton(
                            icon: Icon(
                              //provider.isExpandedMap[season.seasonNumber] == true
                              true == true
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      onTap: () {
                        //provider.toggleSeasonExpansion(season.seasonNumber);
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return Container();
                      },
                    ),
                    //if (provider.isExpandedMap[season.seasonNumber] == true)
                      EpisodesList(
                          episodesMap[season.seasonNumber] ?? []
                      )
                    //else
                      //Container(),
                  ],
                );
              }),
            ),
          );
        } else if (state is TvShowDetailErrorState) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Text('Failed');
        }
      },
    );
  }
}
