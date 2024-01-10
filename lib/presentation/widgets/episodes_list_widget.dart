import 'package:ditonton/domain/entities/tv_show/episode.dart';
import 'package:flutter/material.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> episodes;

  EpisodesList(this.episodes);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: episodes.map((episode) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${episode.episodeNumber}. ${episode.name}',
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Divider()
            ],
          ),
        );
      }).toList(),
    );
  }
}
