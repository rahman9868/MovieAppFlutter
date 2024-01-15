import 'package:ditonton/domain/entities/tv_show/tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/tv_show/detail/tv_show_detail_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../bloc/tv_show/detail/tv_show_detail_bloc.dart';
import '../bloc/tv_show/detail/tv_show_detail_state.dart';
import '../provider/tv_show_detail_notifier.dart';
import 'episodes_list_widget.dart';

class SeasonsList extends StatefulWidget {
  final TvShowDetail tvShowDetail;

  const SeasonsList({super.key, required this.tvShowDetail});

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
        } else if (state is EpisodesTvShowSuccessState) {
          final episodesMap = state.episodeMap;
          final tvShowDetail = state.tvShowDetail;
          final isExpandedMap = state.isExpandedMap;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(tvShowDetail.seasons.length, (index) {
                final season = tvShowDetail.seasons[index];
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
                          if (isExpandedMap[season.seasonNumber] == true)
                            IconButton(
                              icon: Icon(
                                  Icons.keyboard_arrow_up
                              ),
                              onPressed: () {},
                            )
                          else
                            IconButton(
                              icon: Icon(
                                  Icons.keyboard_arrow_down
                              ),
                              onPressed: () {},
                            )
                        ],
                      ),
                      onTap: () async {
                        context.read<TvShowDetailBloc>().add(UpdateToggleSeasonExpansion(widget.tvShowDetail, season.seasonNumber));
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return Container();
                      },
                    ),
                    if (isExpandedMap[season.seasonNumber] == true)
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
          return Text("Failed $state");
        }
      },
    );
  }
}
