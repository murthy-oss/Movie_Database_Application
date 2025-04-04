import 'package:flutter/material.dart';
import 'package:geeks_for_geeks/helpers/db_helper.dart';
import 'package:geeks_for_geeks/models/movie.dart';
import 'movie_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  // DBHelper instance to manage favorites.
  final DBHelper _dbHelper = DBHelper();

  // Constructor with optional key for widget.
  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'), // App bar title.
        backgroundColor: Colors.green, // App bar background color.
        foregroundColor: Colors.white, // App bar text color.
      ),

      // Builds the body of the screen using FutureBuilder
      // to load favorite movies asynchronously.
      body: FutureBuilder<List<Movie>>(
        future: _dbHelper
            .getFavorites(), // Fetches favorite movies from the database.
        builder: (context, snapshot) {
          // If data is not yet available, show a loading spinner.
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there are no favorite movies, display a message.
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite movies'));
          }

          // Displays the list of favorite movies.
          return ListView.builder(
            itemCount: snapshot.data!.length, // Number of favorite movies.
            itemBuilder: (context, index) {
              final movie = snapshot
                  .data![index]; // Fetches the movie at the current index.

              // Displays each movie as a ListTile with an image, title, and year.
              return ListTile(
                leading:
                    Image.network(movie.poster), // Displays the movie poster.
                title: Text(movie.title), // Displays the movie title.
                subtitle: Text(movie.year), // Displays the movie release year.

                // Navigates to the MovieDetailsScreen when tapped.
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(
                          imdbID: movie.imdbID), // Passes the IMDb ID.
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}