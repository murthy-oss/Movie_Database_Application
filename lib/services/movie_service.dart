import 'dart:convert';
import 'dart:developer'; 
import 'package:geeks_for_geeks/models/movie.dart';
import 'package:geeks_for_geeks/models/movie_details.dart';
import 'package:http/http.dart' as http;  

class MovieService {
  // Replace with your OMDb API key.
  final String apiKey = "API_KEY"; 

  // Fetches a list of movies based on the search query.
  Future<List<Movie>> fetchMovies(String searchQuery) async {
    final response = await http.get(
      Uri.parse('http://www.omdbapi.com/?s=$searchQuery&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      
      // Decodes the JSON response and extracts
      // the 'Search' list.
      List<dynamic> moviesJson = jsonDecode(response.body)['Search'];
      
      // Logs the list of movies.
      log(moviesJson.toString()); 
      
      // Maps each JSON object to a Movie
      // instance and returns the list.
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } 
    else {
      // Throws an exception if the request fails.
      throw Exception('Failed to load movies');
    }
  }

  // Fetches detailed information for a specific
  // movie by its IMDb ID.
  Future<MovieDetails> fetchMovieDetails(String imdbID) async {
    final response = await http.get(
      Uri.parse('http://www.omdbapi.com/?i=$imdbID&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      // Decodes the JSON response into a MovieDetails object.
      return MovieDetails.fromJson(jsonDecode(response.body));
    } 
    else {
      // Throws an exception if the request fails.
      throw Exception('Failed to load movie details');
    }
  }
}