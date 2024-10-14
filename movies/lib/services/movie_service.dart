import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie.dart';
import 'package:movies/models/movie_details.dart';

class MovieService {
  final String apiKey = "API_KEY"; // Replace with your OMDb API key

  Future<List<Movie>> fetchMovies(String searchQuery) async {
    final response = await http.get(
        Uri.parse('http://www.omdbapi.com/?s=$searchQuery&apikey=$apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> moviesJson = jsonDecode(response.body)['Search'];
      log(moviesJson.toString());
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<MovieDetails> fetchMovieDetails(String imdbID) async {
    final response = await http
        .get(Uri.parse('http://www.omdbapi.com/?i=$imdbID&apikey=$apiKey'));

    if (response.statusCode == 200) {
      return MovieDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
