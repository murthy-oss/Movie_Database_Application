import 'package:flutter/material.dart';
import 'package:geeks_for_geeks/helpers/db_helper.dart';
import 'package:geeks_for_geeks/models/movie.dart';
import 'package:geeks_for_geeks/models/movie_details.dart';
import 'package:geeks_for_geeks/services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  // IMDb ID of the selected movie.
  final String imdbID;

  // Constructor with required IMDb ID.
  const MovieDetailsScreen({super.key, required this.imdbID});

  // Creates the state for this widget.
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  // Service to fetch movie data from API.
  final MovieService _movieService = MovieService();

  // Database helper instance to manage favorites.
  final DBHelper _dbHelper = DBHelper();

  // Holds the detailed movie information.
  MovieDetails? _movieDetails;

  // Tracks whether the movie is marked as favorite.
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    // Fetch movie details when the screen initializes.
    _loadMovieDetails();

    // Check if the movie is already marked as favorite.
    _checkFavoriteStatus();
  }

  // Fetches movie details from the API using the IMDb ID.
  void _loadMovieDetails() async {
    // API call.
    final movieDetails = await _movieService.fetchMovieDetails(widget.imdbID);
    setState(() {
      // Updates the state with the fetched movie details.
      _movieDetails = movieDetails;
    });
  }

  // Checks if the movie is already marked as a favorite.
  void _checkFavoriteStatus() async {
    // Checks in the database.
    final status = await _dbHelper.isFavorite(widget.imdbID);
    setState(() {
      // Updates the favorite status.
      isFavorite = status;
    });
  }

  // Toggles the favorite status of the movie.
  void _toggleFavorite() async {
    if (isFavorite) {
      // Removes the movie from favorites.
      await _dbHelper.deleteFavorite(widget.imdbID);
    } else {
      // Adds the movie to favorites.
      await _dbHelper.insertFavorite(Movie(
        imdbID: widget.imdbID,
        title: _movieDetails!.title,
        year: _movieDetails!.year,
        type: 'movie', // Assuming it is a movie.
        poster: _movieDetails!.poster,
      ));
    }

    // Re-checks and updates the favorite status.
    _checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'), // App bar title.
        backgroundColor: Colors.green, // App bar background color.
        foregroundColor: Colors.white, // App bar text color.
        actions: [
          // Favorite button to toggle the favorite status.
          IconButton(
            icon: Icon(isFavorite
                ? Icons.favorite
                : Icons
                    .favorite_border), // Icon changes based on favorite status.
            onPressed:
                _toggleFavorite, // Toggles the favorite status when pressed.
          ),
        ],
      ),
      // Displays a loading indicator if movie details are not loaded yet.
      body: _movieDetails == null
          ? const Center(
              child: CircularProgressIndicator()) // Shows a loading spinner.
          : Padding(
              padding:
                  const EdgeInsets.all(8.0), // Adds padding around the content.
              child: Column(
                children: [
                  Image.network(
                      _movieDetails!.poster), // Displays the movie poster.
                  const SizedBox(height: 10), // Adds spacing.
                  // Displays the movie title with bold styling.
                  Text(
                    _movieDetails!.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10), // Adds spacing.
                  // Displays the IMDb rating of the movie.
                  Text('Rating: ${_movieDetails!.imdbRating}'),
                  const SizedBox(height: 10), // Adds spacing.
                  // Displays the plot/description of the movie.
                  Text(_movieDetails!.plot),
                ],
              ),
            ),
    );
  }
}