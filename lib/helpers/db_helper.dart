import 'package:geeks_for_geeks/models/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // Singleton pattern to ensure only one
  // instance of DBHelper is created.
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  // Private constructor for singleton implementation.
  DBHelper._internal();

  // Holds the database instance.
  Database? _database;

  // Returns the database instance, initializes
  // it if not already created.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initializes the database and returns
  // the database object.
  Future<Database> _initDB() async {
    // Constructs the path to the 'movies.db' database file.
    String path = join(await getDatabasesPath(), 'movies.db');
    // Opens the database, creating it if it doesn't exist.
    return await openDatabase(
      path,
      version: 1, // Database version.
      onCreate: _onCreate, // Executes _onCreate if the database is new.
    );
  }

  // Called when the database is created; creates the 'favorites' table.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        imdbID TEXT, 
        title TEXT, 
        year TEXT, 
        poster TEXT, 
        type TEXT
      )
    '''); // Creates the 'favorites' table with relevant columns.
  }

  // Inserts a movie into the 'favorites' table.
  Future<void> insertFavorite(Movie movie) async {
    final db = await database; // Gets the database instance.
    await db.insert(
      'favorites', // Target table.
      movie.toMap(), // Converts the movie to a map.
      conflictAlgorithm: ConflictAlgorithm.replace, // Replaces if conflict.
    );
  }

  // Retrieves all movies from the 'favorites' table.
  Future<List<Movie>> getFavorites() async {
    final db = await database; // Gets the database instance.
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    // Converts the list of maps into a list of Movie objects.
    return List.generate(maps.length, (i) {
      return Movie(
        imdbID: maps[i]['imdbID'],
        title: maps[i]['title'],
        year: maps[i]['year'],
        poster: maps[i]['poster'],
        type: maps[i]['type'],
      );
    });
  }

  // Deletes a movie from the 'favorites' table based on its IMDb ID.
  Future<bool> deleteFavorite(String imdbID) async {
    // Gets the database instance.
    final db = await database;
    final int count = await db.delete(
      'favorites',
      where: 'imdbID = ?',
      whereArgs: [imdbID], // Filters by the provided IMDb ID.
    );

    // Returns true if a row was deleted.
    return count > 0;
  }

  Future<bool> isFavorite(String imdbID) async {
    final db = await database; // Gets the database instance.
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'imdbID = ?', // Filters by the provided IMDb ID.
      whereArgs: [imdbID],
    );

    // Returns true if a movie with the given IMDb ID exists in favorites.
    return maps.isNotEmpty;
  }
}