import 'package:flutter/material.dart';
import 'package:movies/helpers/db_helper.dart';
import 'package:movies/models/movie.dart';
import 'movie_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final DBHelper _dbHelper = DBHelper();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _dbHelper.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite movies'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movie = snapshot.data![index];
              return ListTile(
                leading: Image.network(movie.poster),
                title: Text(movie.title),
                subtitle: Text(movie.year),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailsScreen(imdbID: movie.imdbID),
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
