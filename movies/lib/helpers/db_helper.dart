import 'package:movies/models/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

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
    ''');
  }

  Future<void> insertFavorite(Movie movie) async {
    final db = await database;
    await db.insert(
      'favorites',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Movie>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

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

  Future<void> deleteFavorite(String imdbID) async {
    final db = await database;
    await db.delete('favorites', where: 'imdbID = ?', whereArgs: [imdbID]);
  }

  Future<bool> isFavorite(String imdbID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'imdbID = ?',
      whereArgs: [imdbID],
    );
    return maps.isNotEmpty;
  }
}
