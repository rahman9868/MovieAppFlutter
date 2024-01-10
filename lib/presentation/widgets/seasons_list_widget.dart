import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../provider/tv_show_detail_notifier.dart';
import 'episodes_list_widget.dart';

class SeasonsList extends StatefulWidget {
  @override
  _SeasonsListState createState() => _SeasonsListState();
}

class _SeasonsListState extends State<SeasonsList> {
  Map<int, bool> isExpandedMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TvShowDetailNotifier>(
      builder: (context, provider, child) {
        if (provider.tvShowState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.tvShowState == RequestState.Loaded) {
          final movie = provider.tvShow;
          if (provider.episodeState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.episodeState == RequestState.Loaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(movie.seasons.length, (index) {
                  final season = movie.seasons[index];
                  if (isExpandedMap.isEmpty) {
                    isExpandedMap = Map.fromIterable(movie.seasons,
                        key: (season) => season.seasonNumber,
                        value: (_) => false);
                  }
                  print("isExpandedList assign ${isExpandedMap.values}");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Season ${season.seasonNumber}',
                            ),
                            IconButton(
                              icon: Icon(
                                isExpandedMap[season.seasonNumber] == true
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            isExpandedMap[season.seasonNumber] =
                                !isExpandedMap[season.seasonNumber]!;
                          });
                        },
                      ),
                      Builder(
                        builder: (context) {
                          return Container(); // Builder requires a widget to be returned
                        },
                      ),
                      if (isExpandedMap[season.seasonNumber] == true)
                        EpisodesList(
                            provider.episodesMap[season.seasonNumber] ?? [])
                      else
                        Container(),
                    ],
                  );
                }),
              ),
            );
          } else {
            return Text(provider.message);
          }
        } else {
          return Text(provider.message);
        }
      },
    );
  }
}
