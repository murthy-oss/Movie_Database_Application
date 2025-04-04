import 'package:flutter/material.dart';
import 'package:geeks_for_geeks/models/movie.dart';
import 'package:geeks_for_geeks/screens/favorites_screen.dart';
import 'package:geeks_for_geeks/services/movie_service.dart';

import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  // Constructor with optional key for widget.
  const HomeScreen({super.key});

  // Creates the state object.
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for the search input.
  final TextEditingController _controller = TextEditingController();

  // Instance of MovieService to fetch movies.
  final MovieService _movieService = MovieService();

  // List to store fetched movies.
  List<Movie> _movies = [];

  // Fetches movies based on the search query
  // and updates the UI.
  void _searchMovies() async {
    // Fetches movies.
    final movies = await _movieService.fetchMovies(_controller.text);
    setState(() {
      // Updates the movie list.
      _movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GFG Movies App'), // App bar title.
        backgroundColor: Colors.green, // App bar background color.
        foregroundColor: Colors.white, // App bar text color.
        actions: [
          // Favorite button navigates to the FavoritesScreen.
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Input field for entering the search query.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller:
                  _controller, // Binds the controller to the input field.
              decoration: const InputDecoration(
                labelText: 'Search for movies', // Input field hint text.
              ),
            ),
          ),
          // Button to trigger the search function.
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button background color.
                foregroundColor: Colors.white, // Button text color.
              ),
              onPressed: _searchMovies, // Calls _searchMovies on press.
              child: const Text(
                "Search", // Button text.
              )),
          // Displays search results or a message if no movies are found.
          Expanded(
            child: _movies.isEmpty
                ? const Center(
                    child: Text('No movies found')) // No results message.
                : ListView.builder(
                    itemCount: _movies.length, // Number of movies to display.
                    itemBuilder: (context, index) {
                      final movie = _movies[
                          index]; // Fetches the movie at the current index.
                      return Card(
                        margin: const EdgeInsets.all(8.0), // Card margin.
                        elevation: 5, // Card elevation effect.
                        child: ListTile(
                          leading: Image.network(
                              movie.poster), // Displays the movie poster.
                          title: Text(movie.title), // Displays the movie title.
                          subtitle:
                              Text(movie.year), // Displays the movie year.
                          trailing: const Icon(Icons
                              .arrow_forward), // Arrow icon for navigation.
                          onTap: () {
                            // Navigates to MovieDetailsScreen with the selected movie's IMDb ID.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsScreen(imdbID: movie.imdbID),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}