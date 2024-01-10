import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_show/tv_show_seasons_model.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_show/tv_show_detail.dart';

class TvShowDetailResponse extends Equatable {
  final bool adult;
  final String backdropPath;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final String status;
  final List<SeasonModel> seasons;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  TvShowDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.seasons,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvShowDetailResponse.fromJson(Map<String, dynamic> json) {
    return TvShowDetailResponse(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      episodeRunTime: List<int>.from(json['episode_run_time']),
      firstAirDate: json['first_air_date'],
      genres: List<GenreModel>.from(
        json['genres'].map((genreJson) => GenreModel.fromJson(genreJson)),
      ),
      homepage: json['homepage'],
      id: json['id'],
      inProduction: json['in_production'],
      languages: List<String>.from(json['languages']),
      lastAirDate: json['last_air_date'],
      name: json['name'],
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
      originCountry: List<String>.from(json['origin_country']),
      originalLanguage: json['original_language'],
      originalName: json['original_name'],
      overview: json['overview'],
      popularity: json['popularity'],
      posterPath: json['poster_path'],
      status: json['status'],
      seasons: List<SeasonModel>.from(
        json['seasons'].map((season) => SeasonModel.fromJson(season)),
      ),
      tagline: json['tagline'],
      type: json['type'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
    );
  }

  TvShowDetail toEntity() {
    return TvShowDetail(
      adult: adult,
      backdropPath: backdropPath,
      episodeRunTime: episodeRunTime,
      firstAirDate: firstAirDate,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      homepage: homepage,
      id: id,
      inProduction: inProduction,
      languages: languages,
      lastAirDate: lastAirDate,
      name: name,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      status: status,
      seasons: this.seasons.map((season) => season.toEntity()).toList(),
      tagline: tagline,
      type: type,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        homepage,
        id,
        inProduction,
        languages,
        lastAirDate,
        name,
        numberOfEpisodes,
        numberOfSeasons,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        status,
        tagline,
        type,
        voteAverage,
        voteCount,
      ];
}
