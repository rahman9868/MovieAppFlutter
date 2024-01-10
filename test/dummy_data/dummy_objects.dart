import 'package:ditonton/data/models/movie/movie_table.dart';
import 'package:ditonton/data/models/tv_show/tv_show_seasons_model.dart';
import 'package:ditonton/data/models/tv_show/tv_show_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  voteAverage: 7.2,
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  voteAverage: 7.2,
  overview: 'overview',
  isMovie: 1
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvShow = TvShow(
  backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
  firstAirDate: "2023-01-23",
  genreIds: [9648, 18],
  id: 11,
  name: "Dirty Linen",
  originCountry: ["PH"],
  originalLanguage: "tl",
  originalName: "Dirty Linen",
  overview:
  "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
  popularity: 2797.914,
  posterPath: "/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg",
  voteAverage: 8.0,
  voteCount: 13,
);

final testTvShowList = [testTvShow];

final testTvShowDetail = TvShowDetail(
    adult: false,
    backdropPath: "/path.jpg",
    episodeRunTime: [
      60
    ],
    firstAirDate: "2011-04-17",
    genres: [
      Genre(id: 1, name: "Action")
    ],
    homepage: "https://google.com",
    id: 1,
    inProduction: false,
    languages: [
      "en"
    ],
    lastAirDate: "2019-05-19",
    name: "Game of Thrones",
    numberOfEpisodes: 73,
    numberOfSeasons: 8,
    originCountry: [
      "US"
    ],
    originalLanguage: "en",
    originalName: "Game of Thrones",
    overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
    popularity: 346.098,
    posterPath: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg",
    status: "Ended",
    seasons: [Season(
        airDate: "2019-05-19",
        episodeCount: 1,
        id: 1,
        name: "Name",
        overview: "overview",
        posterPath: "posterPath",
        seasonNumber: 1,
        voteAverage: 5.0
    )],
    tagline: "Winter Is Coming",
    type: "Scripted",
    voteAverage: 8.438,
    voteCount: 21390
);

final testWatchlistTvShow = TvShow.watchlist(
  id: 1,
  name: 'Game of Thrones',
  posterPath: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg",
  voteAverage: 8.438,
  overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
);

final testTvShowTable = MovieTable(
  id: 1,
  title: 'Game of Thrones',
  posterPath: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg",
  voteAverage: 8.438,
  overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  isMovie: 0
);

final testTvShowMap = {
  'id': 1,
  'overview': "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  'posterPath': '/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg',
  'title': 'Game of Thrones',
  'voteAverage': 8.438,
  'isMovie': 0
};
