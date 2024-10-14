import 'package:flutter/material.dart';
import 'package:movies/helpers/db_helper.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/movie_details.dart';
import 'package:movies/services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String imdbID;

  const MovieDetailsScreen({super.key, required this.imdbID});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieService _movieService = MovieService();
  final DBHelper _dbHelper = DBHelper();
  MovieDetails? _movieDetails;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
    _checkFavoriteStatus();
  }

  void _loadMovieDetails() async {
    final movieDetails = await _movieService.fetchMovieDetails(widget.imdbID);
    setState(() {
      _movieDetails = movieDetails;
    });
  }

  void _checkFavoriteStatus() async {
    final status = await _dbHelper.isFavorite(widget.imdbID);
    setState(() {
      isFavorite = status;
    });
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await _dbHelper.deleteFavorite(widget.imdbID);
    } else {
      await _dbHelper.insertFavorite(Movie(
        imdbID: widget.imdbID,
        title: _movieDetails!.title,
        year: _movieDetails!.year,
        type: 'movie', // assuming movie
        poster: _movieDetails!.poster,
      ));
    }
    _checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _movieDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network(_movieDetails!.poster),
                  const SizedBox(height: 10),
                  Text(
                    _movieDetails!.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Rating: ${_movieDetails!.imdbRating}'),
                  const SizedBox(height: 10),
                  Text(_movieDetails!.plot),
                ],
              ),
            ),
    );
  }
}
