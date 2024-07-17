import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/store.dart';
import '../models/user.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'my_storee.db';

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  // Initialize the database
  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, dbName);
    final db = await openDatabase(
      databasePath,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE stores(
            id INTEGER PRIMARY KEY,
            name TEXT,
            longitude REAL,
            latitude REAL,
            distance REAL,
            user_id INTEGER
          )
        ''');

        await db.execute('''
         CREATE TABLE users(
         id INTEGER PRIMARY KEY AUTOINCREMENT,  // Ensure auto-increment
         username TEXT,
         email TEXT UNIQUE,
         phone TEXT,
         password TEXT
        );

        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,  // Ensure auto-increment
            username TEXT,
            email TEXT UNIQUE,
            phone TEXT,
            password TEXT
          );
          ''');
        }
      },
    );
    return db;
  }

  // CRUD operations for users
  Future<int> createUser(User user) async {
  final db = await getDatabase();
  return await db.insert(
    'users',  // Insert into 'users' table
    user.toMap(),  // Exclude `id` for auto-increment
    conflictAlgorithm: ConflictAlgorithm.replace,  // Handle conflicts
  );
}

Future<User?> getUserByEmail(String email) async {
  final db = await getDatabase();
  final result = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (result.isEmpty) {
    return null;  // No user found with the given email
  }

  final user = User.fromMap(result.first);
  if (user.id == null) {
    throw Exception("User ID is null after fetching.");  // Handle missing ID
  }
  return user;
}


  // CRUD operations for stores
  Future<int> insertStore(Store store) async {
    final db = await getDatabase();
    return await db.insert(
      'stores',
      store.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteStore(int id) async {
    final db = await getDatabase();
    await db.delete(
      'stores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Store>> getAllStores() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('stores');
    return List.generate(maps.length, (i) {
      return Store(
        id: maps[i]['id'],
        name: maps[i]['name'],
        longitude: maps[i]['longitude'],
        latitude: maps[i]['latitude'],
        distance: maps[i]['distance'],
      );
    });
  }

  Future<Store?> getStoreById(int storeId) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'stores',
      where: 'id = ?',
      whereArgs: [storeId],
    );
    return maps.isNotEmpty ? Store.fromMap(maps.first) : null;
  }
}
