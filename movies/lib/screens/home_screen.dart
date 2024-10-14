import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/favorites_screen.dart';
import 'package:movies/services/movie_service.dart';

import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];

  void _searchMovies() async {
    final movies = await _movieService.fetchMovies(_controller.text);
    setState(() {
      _movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GFG Movies App'),
        actions: [
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search for movies',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: _searchMovies,
              child: const Text(
                "Search",
                style: TextStyle(color: Colors.black),
              )),
          Expanded(
            child: _movies.isEmpty
                ? const Center(child: Text('No movies found'))
                : ListView.builder(
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      final movie = _movies[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5,
                        child: ListTile(
                          leading: Image.network(movie.poster),
                          title: Text(movie.title),
                          subtitle: Text(movie.year),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
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
