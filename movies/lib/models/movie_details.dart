class MovieDetails {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String genre;
  final String director;
  final String actors;
  final String plot;
  final String poster;
  final String imdbRating;

  MovieDetails({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.genre,
    required this.director,
    required this.actors,
    required this.plot,
    required this.poster,
    required this.imdbRating,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json['Title'],
      year: json['Year'],
      rated: json['Rated'],
      released: json['Released'],
      genre: json['Genre'],
      director: json['Director'],
      actors: json['Actors'],
      plot: json['Plot'],
      poster: json['Poster'],
      imdbRating: json['imdbRating'],
    );
  }
}
