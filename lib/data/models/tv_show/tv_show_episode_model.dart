class Episode {
  final String? airDate;
  final int? episodeNumber;
  final int id;
  final String name;
  final String? overview;
  final String? productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;
  final double? voteAverage;
  final int? voteCount;

  Episode({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      airDate: json['air_date'],
      episodeNumber: json['episode_number'],
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      productionCode: json['production_code'],
      runtime: json['runtime'],
      seasonNumber: json['season_number'],
      showId: json['show_id'],
      stillPath: json['still_path'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
    );
  }
}
