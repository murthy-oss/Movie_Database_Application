class Movie {
  // Movie properties
  final String imdbID;
  final String title;
  final String year;
  final String poster;
  final String type;

  // Constructor to initialize the Movie object.
  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  // Creates a Movie object from a JSON map.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'],
      title: json['Title'],
      year: json['Year'],
      poster: json['Poster'],
      type: json['Type'],
    );
  }

  // Converts the Movie object into a map.
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