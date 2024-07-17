import 'package:flutter/material.dart';
import 'package:ass2/SQLite/database_helper.dart';
import 'package:ass2/models/store.dart';
import 'package:ass2/models/user.dart';

class StoreProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  User? _currentUser; // Stores information about the logged-in user
  List<Store> _stores = [];
  List<Store> _favoriteStores = [];

  // Getters
  List<Store> get stores => _stores;
  List<Store> get favoriteStores => _favoriteStores;

  User? get currentUser => _currentUser;

  // Set the current user and fetch their favorite stores
  void setCurrentUser(User user) {
    if (user.id == null) {
      throw Exception(
          "User ID is null. Cannot fetch favorites."); // Handle the null case
    }
    _currentUser = user;
    fetchUserFavorites(user.id!); // Ensure `user.id` is not null
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null; // Used when signing out
    _favoriteStores = [];
    notifyListeners();
  }

  void addToFavorites(Store store) async {
    if (_currentUser == null) return; // Ensure there's a logged-in user
    _favoriteStores.add(store);
    await _dbHelper.insertStore(
        store.copyWith(user_id: _currentUser!.id)); // Store with user_id
    notifyListeners();
  }

  Future<void> removeFromFavorites(Store store) async {
    if (_currentUser == null) return; // Ensure there's a logged-in user
    _favoriteStores.remove(store);
    await _dbHelper.deleteStore(store.id); // Remove from the database
    notifyListeners();
  }

  Future<void> fetchUserFavorites(int userId) async {
    // Using `user_id`
    final db = await _dbHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'stores',
      where: 'user_id = ?', // Using `user_id` in the query
      whereArgs: [userId], // Pass `userId` as the argument
    );

    _favoriteStores = maps.map((map) => Store.fromMap(map)).toList();
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> fetchInitialData() async {
    // The initial data for store testing
    _stores = [
      Store(
          id: 1,
          name: "Store 1",
          longitude: 31.23528,
          latitude: 30.04167,
          distance: 0),
      Store(
          id: 2,
          name: "Store 2",
          longitude: 29.91611,
          latitude: 31.20194,
          distance: 0),
      Store(
          id: 3,
          name: "Store 3",
          longitude: 31.20889,
          latitude: 30.01222,
          distance: 0),
      Store(
          id: 4,
          name: "Store 4",
          longitude: 31.33667,
          latitude: 31.26000,
          distance: 0),
      Store(
          id: 5,
          name: "Store 5",
          longitude: 32.55000,
          latitude: 29.96722,
          distance: 0),
    ];

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}
