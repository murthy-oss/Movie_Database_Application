class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String poster;
  final String type;

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'],
      title: json['Title'],
      year: json['Year'],
      poster: json['Poster'],
      type: json['Type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imdbID': imdbID,
      'title': title,
      'year': year,
      'poster': poster,
      'type': type,
    };
  }
}
